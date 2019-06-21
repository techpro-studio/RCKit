//
//  AppStateManager.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

public enum AppState{
    case active
    case inactive
    case background
    case terminated
}


public protocol AppStateManager {
    var state: BehaviorRelay<AppState> { get }
}



public class DefaultAppStateManager: AppStateManager{
    
    public let state: BehaviorRelay<AppState> = BehaviorRelay(value: .active)
    
    private let q = DispatchQueue(label: "AppStateManager.sync.queue")
    
    public init(){
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) {[weak self] (_) in
            self?.tryToApplyState(state: .active)
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self](_) in
            self?.tryToApplyState(state: .background)
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) {[weak self] (_) in
            self?.tryToApplyState(state: .terminated)
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self](_) in
            self?.tryToApplyState(state: .inactive)
        }
        
    }
    
    
    private func tryToApplyState(state: AppState){
        q.sync {
            if self.state.value != state{
                self.state.accept(state)
            }
        }
    }
    
    
}



