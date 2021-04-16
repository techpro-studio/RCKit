//
//  ErrorThrowablePresenter.swift
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

public protocol ErrorThrowablePresenter {
    var error: PublishSubject<Error> { get }
}

public protocol ErrorThrowablePresenterContainer: DisposeBagContainer {
    var errorThrowablePresenter: ErrorThrowablePresenter { get }
}

public extension ErrorThrowablePresenterContainer where Self: UIViewController {
   func subscribeOnErrors() {
    self.errorThrowablePresenter.error.asObservable().observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] error in
            guard let self = self else { return }
            if let common = error as? CommonErrors, common == .userCancelled {
                return
            }
            self.alert(error: error)
        }).disposed(by: self.disposeBag)
    }
}
