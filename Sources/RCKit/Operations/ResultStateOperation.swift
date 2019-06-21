//
//  ResultStateOperation.swift
//  RCKit
//
//  Created by Alex on 6/20/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation


public enum OperationResult<T> {
    case value(T)
    case error(Error)
    case cancelled
}

open class ResultStateOperation<Result>: StateOperation {

    public var result: OperationResult<Result>!

    open func finishWithError(error: Error) {
        self.result = .error(error)
        self.finish()
    }

    open func finishWithValue(value: Result) {
        self.result = .value(value)
        self.finish()
    }

    open func finishWithCancelledResult() {
        self.result = .cancelled
        self.finish()
    }

    override open func cancel() {
        self.finishWithCancelledResult()
    }

    deinit {
        #if DEBUG
        print("Deinitialized: ", type(of: self))
        #endif
    }
}
