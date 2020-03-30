//
//  ModalCoordinator.swift
//  RCKit
//
//  Created by Alex on 30.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

open class ModalCoordinator:  BaseCoordinator, UIAdaptivePresentationControllerDelegate  {

    public var finished: (()-> Void)!

    public unowned let sourceViewController: UIViewController
    public var navigationController: UINavigationController!

    public init(sourceViewController: UIViewController, container: Container) {
        self.sourceViewController = sourceViewController
        super.init(container: container)
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

    public func showViewController(viewContoller: UIViewController, modalPresentationStyle: UIModalPresentationStyle = .pageSheet) {
       navigationController = UINavigationController(rootViewController: viewContoller)
        navigationController.modalPresentationStyle = modalPresentationStyle
       navigationController.presentationController!.delegate = self
       sourceViewController.present(navigationController, animated: true, completion: nil)
    }
}
