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
