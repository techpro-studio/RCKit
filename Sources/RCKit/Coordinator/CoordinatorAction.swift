//
//  CoordinatorAction.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications



public protocol CoordinatorAction {
    
}



public protocol CoordinatorActionFactory {
    func make(from userActivity: NSUserActivity?)->CoordinatorAction?
    func make(from launchOptions: [UIApplication.LaunchOptionsKey: Any]?)->CoordinatorAction?
    func make(from notification: [AnyHashable:Any]?)->CoordinatorAction?
    func make(from shortcutItem: UIApplicationShortcutItem)->CoordinatorAction?
    @available(iOS 10.0, *)
    func make(from response: UNNotificationResponse?)->CoordinatorAction?
}
