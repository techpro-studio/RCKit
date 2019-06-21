//
//  ViewControllerProtocol.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import UIKit

public protocol ModuleRoutes:  ViewControllerContainer {}

public protocol ViewControllerContainer: AnyObject {
    var viewController: UIViewController { get }
}

public protocol ViewContainer {
    var view: UIView { get }
}

public extension ViewContainer where Self: UIView {
    var view: UIView {
        return self
    }
}

public extension ViewControllerContainer where Self: UIViewController{
     var viewController: UIViewController {
        return self
    }
}
