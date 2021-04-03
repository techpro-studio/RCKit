//
//  SpaceshipOperator.swift
//  ReInvest
//
//  Created by Alex on 25.03.2021.
//

import Foundation
import RxCocoa
import RxSwift

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
