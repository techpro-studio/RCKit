//
//  KeyboardObserver.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RxSwift
import UIKit


public protocol KeyBoardObserver {
    var keyBoardDidChange: PublishSubject<KeyBoardChangeInfo> { get }
}

public struct KeyBoardChangeInfo{
    let rect: CGRect
    let animationDuration: Double
    let animationCurve: UInt
}

public class DefaultKeyboardObserver: NSObject, KeyBoardObserver {
    
    public let keyBoardDidChange = PublishSubject<KeyBoardChangeInfo>()
    
    public override init() {
        super.init()
        subscribe()
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handleChange),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    
    private func getInfoFromNotification(notification: Notification)->KeyBoardChangeInfo{
        let userInfo = notification.userInfo ?? [:]
        let endFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions().rawValue
        return KeyBoardChangeInfo(rect: endFrame, animationDuration: duration, animationCurve: animationCurveRaw)
    }
    
    @objc private func handleChange(notification: Notification) {
        let info = self.getInfoFromNotification(notification: notification)
        self.setNewInfo(newInfo: info)
    }
    
    
    private func setNewInfo(newInfo: KeyBoardChangeInfo) {
        self.keyBoardDidChange.onNext(newInfo)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}
