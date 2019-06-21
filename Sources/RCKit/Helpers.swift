//
//  Helpers.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

public func abstractMethod()->Never{
    fatalError("this method should be overriden")
}

class WeakContainer<T: AnyObject> {
    weak var value: T?
    init(value: T) {
        self.value = value
    }
}

public struct Device {
    static public func for5<T>(_ value: T, for6 sixValue: T, for6Plus sixPlusValue: T, forX XValue: T, forXSMax xsMaxValue: T) -> T {
        switch UIScreen.main.bounds.width {
        case 320.0:
            return value
        case 414.0:
            if UIScreen.main.bounds.height > 750 {
                return xsMaxValue
            }
            return sixPlusValue
        default:
            if UIScreen.main.bounds.height > 700 {
                return XValue
            }
            return sixValue
        }
    }
}


public func dispatchInMainSync<T>(f: @escaping() ->T)->T{
    if Thread.isMainThread{
        return f()
    }else{
        return DispatchQueue.main.sync(execute: f)
    }
}


infix operator <->

public func <-> <T>(property: ControlProperty<T>, BehaviorRelay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = BehaviorRelay.asObservable()
        .bind(to: property)
    
    let bindToBehaviorRelay = property
        .subscribe(onNext: { value in
            BehaviorRelay.accept(value)
        }, onCompleted: {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToBehaviorRelay)
}
