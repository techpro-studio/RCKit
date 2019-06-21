//
//  ModelProtocols.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

public protocol DomainConvertibleType {
    associatedtype DomainType
    
    func asDomain() -> DomainType
}



