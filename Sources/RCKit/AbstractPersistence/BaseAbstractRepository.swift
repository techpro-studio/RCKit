//
//  BaseAbstractRepository.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation


public protocol BaseAbstractRepository {
    associatedtype T
    func save(value: T)
    func remove(value: T)
    func getById(id: String) -> T?
    func remove(id: String)
    func get(predicate: NSPredicate) -> T?
}
