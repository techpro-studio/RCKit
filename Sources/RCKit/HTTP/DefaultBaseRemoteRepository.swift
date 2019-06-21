//
//  DefaultBaseRemoteRepository.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation


open class DefaultBaseRemoteRepository{
    
    public let requestFactory:RequestFactory
    public let httpPerformer: HTTPRequestPerformer
    
    public init(requestFactory:RequestFactory, httpPerformer: HTTPRequestPerformer){
        self.httpPerformer = httpPerformer
        self.requestFactory = requestFactory
    }
}
