//
//  ReachabilityManager.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SystemConfiguration

public protocol ReachabilityManager {
    var connectionIsReachable: BehaviorRelay<Bool> { get }
}


extension SCNetworkReachabilityFlags {

    var connectionIsReachable: Bool {
        return contains(.reachable)
    }
}

extension SCNetworkReachability {

    var connectionReachable: Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self, &flags)
        return flags.connectionIsReachable
    }
}


public class DefaultReachabilityManager: NSObject, ReachabilityManager {

    public let connectionIsReachable: BehaviorRelay<Bool>
    
    private let appStateManager: AppStateManager
    
    private let disposeBag = DisposeBag()

    private let reachability: SCNetworkReachability
    
    private let lock = NSLock()

    public init(appStateManager: AppStateManager) {
        
        self.appStateManager = appStateManager

        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)

        reachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress)!

        connectionIsReachable = BehaviorRelay(value: reachability.connectionReachable)
        
        super.init()

        appStateManager.state.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state{
            case .active:
                self.refresh()
                self.startNotifier()
            case .inactive:
                self.stopNotifier()
            default:
                break
            }
        }).disposed(by: self.disposeBag)
    }

    private func startNotifier() {
        let weakSelf = WeakContainer(value: self)

        let callback: SCNetworkReachabilityCallBack = { _, flags, info in
            guard let info = info else { return }
            let converted = Unmanaged<WeakContainer<DefaultReachabilityManager>>.fromOpaque(info).takeUnretainedValue()

            converted.value?.setValue(value: flags.connectionIsReachable)
        }

        let opaqueSelf = Unmanaged<WeakContainer<DefaultReachabilityManager>>.passUnretained(weakSelf).toOpaque()


        var context = SCNetworkReachabilityContext(
            version: 0,
            info: UnsafeMutableRawPointer(opaqueSelf),
            retain: { (info: UnsafeRawPointer) -> UnsafeRawPointer in
                let unmanagedWeakifiedReachability = Unmanaged<WeakContainer<DefaultReachabilityManager>>.fromOpaque(info)
                _ = unmanagedWeakifiedReachability.retain()
                return UnsafeRawPointer(unmanagedWeakifiedReachability.toOpaque())
        },
            release: { (info: UnsafeRawPointer) -> Void in
                let unmanagedWeakifiedReachability = Unmanaged<WeakContainer<DefaultReachabilityManager>>.fromOpaque(info)
                unmanagedWeakifiedReachability.release()
        },
            copyDescription: nil
        )


        var result = SCNetworkReachabilitySetCallback(reachability, callback, &context)

        if !result {
            print("failed to setup callback")
            return
        }

        result = SCNetworkReachabilitySetDispatchQueue(reachability, q)

        if !result {
            print("failed to setup q")
            return
        }
    }

    private func stopNotifier() {
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
    }


    private func refresh(){
        setValue(value: reachability.connectionReachable)
    }
    
    
    private func setValue(value: Bool){
        lock.lock()
        if self.connectionIsReachable.value != value{

            self.connectionIsReachable.accept(value)
        }
        lock.unlock()
    }
    
    deinit {
        stopNotifier()
    }
    
}

