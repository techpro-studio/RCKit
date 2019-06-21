//
//  RunObservable.swift
//  GoMoney
//

import Foundation
import RxSwift

public protocol DisposableContainer: AnyObject {
    var disposable: Disposable? { get set }
}

public extension LoadablePresenter where Self: ErrorThrowablePresenter & DisposableContainer {

    func runObservable(observable: Observable<Void>) {
        self.disposable?.dispose()
        self.isLoading.accept(true)
        disposable = observable.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.isLoading.accept(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading.accept(false)
                self.error.onNext(error)
        })
    }
}
