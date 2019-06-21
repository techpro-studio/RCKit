//
//  UIViewController+Extensions.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    public func alert(error:Error, completionHandler: (()->Void)?=nil){
        self.alert(message: error.localizedDescription, title: NSLocalizedString("Error", comment: ""), completionHandler: completionHandler)
    }
    
    public func alert(message:String, title:String, completionHandler: (()->Void)?=nil){
        dispatchInMainSync {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {_ in
                completionHandler?()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
