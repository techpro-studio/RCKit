//
//  LoadablePresenter.swift
//  GoMoney
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

public protocol LoadablePresenter: DisposeBagContainer {
    var isLoading: BehaviorRelay<Bool> { get }
}

public protocol DisposeBagContainer: AnyObject {
    var disposeBag: DisposeBag { get }
}

public protocol LoadablePresenterContainer: DisposeBagContainer {
    var loadablePresenter: LoadablePresenter { get }
    var activityAnimator: ActivityAnimator! { get }
}

public extension LoadablePresenterContainer where Self: UIViewController {

    func subscribeOnLoading() {
        self.loadablePresenter.isLoading.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: {[weak self] loading in
            guard let self = self else { return }
            if loading {
                self.activityAnimator.startActivity()
            } else {
                self.activityAnimator.stopActivity()
            }
        }).disposed(by: self.disposeBag)
    }

}
