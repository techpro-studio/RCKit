//
//  Coordinator.swift
//  RxCleanKit
//
//  Created by Alex on 4/6/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import RxSwift
import Swinject



public protocol Coordinator:class {
    func stop(completionHandler: @escaping ()->Void)
    func process(action:CoordinatorAction?)
    func start()
}


open class BaseCoordinator:NSObject, Coordinator{
    
    
    public let container: Container
    let disposeBag =  DisposeBag()
    public var childCoordinators: [Coordinator] = []
    
    public init(container: Container) {
        self.container = container
    }
    
    public func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    public func removeDependency(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    public func stop(completionHandler: @escaping ()->Void){
        let group = DispatchGroup()
        self.childCoordinators.forEach { (coordinator) in
            group.enter()
            coordinator.stop {[weak self] in
                guard let self = self else { return }
                self.removeDependency(coordinator)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.performStop {
                completionHandler()
            }
        }
    }
    
    open func performStop(completionHandler: @escaping ()->Void){
        completionHandler()
    }
    
    open func process(action:CoordinatorAction?){
        
    }
    
    open func start() {
        abstractMethod()
    }
    
    deinit {
        print("DEINITED", type(of:self))
    }
}
