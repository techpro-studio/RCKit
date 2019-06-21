//
//  BaseFactory.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import Swinject


open class BaseFactory{
    
    public unowned let container: Container
    
    public init(container: Container){
        self.container = container
    }
    
}
