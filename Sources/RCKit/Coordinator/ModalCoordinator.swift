//
//  ModalCoordinator.swift
//  RCKit
//
//  Created by Alex on 30.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import Swinject

open class ModalCoordinator:  BaseCoordinator, UIAdaptivePresentationControllerDelegate  {

    public var finished: (()-> Void)!

    public unowned let sourceViewController: UIViewController
    public let navigationController: UINavigationController

    public init(sourceViewController: UIViewController, container: Container) {
        self.sourceViewController = sourceViewController
        self.navigationController = UINavigationController()
        super.init(container: container)
        self.navigationController.delegate = self
    }

    override final func performStop(completionHandler: @escaping () -> Void) {
        self.navigationController.dismiss(animated: true, completion: completionHandler)
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.finished()
    }

    public func close() {
        self.stop {[weak self] in
            self?.finished()
        }
    }

    public func showRootViewController(viewContoller: UIViewController, modalPresentationStyle: UIModalPresentationStyle = .pageSheet) {
       navigationController.setViewControllers([viewContoller], animated: false)
       navigationController.modalPresentationStyle = modalPresentationStyle
       sourceViewController.present(navigationController, animated: true, completion: nil)
    }
}
