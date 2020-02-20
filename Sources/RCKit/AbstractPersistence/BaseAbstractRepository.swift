//
//  BaseAbstractRepository.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation



public protocol Identifiable {
    associatedtype Identifier
    var id: Identifier { get }
}

public protocol BaseAbstractRepository {
    associatedtype T: Identifiable
    func save(value: T)
    func remove(value: T)
    func getById(id: T.Identifier) -> T?
    func remove(id: T.Identifier)
    func get(predicate: NSPredicate) -> T?
}
