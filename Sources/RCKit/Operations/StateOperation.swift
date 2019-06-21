//
//  StateOperation.swift
//  RxCleanKit
//
//  Created by Alex on 6/19/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation


open class StateOperation: Operation {

    public enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
        case cancelled = "isCancelled"
    }

    public override init() {
        super.init()
    }

    private let lock = NSLock()

    private var _state = State.ready

    private var state: State {
        get {
            return _state
        }

        set(newState) {
            defer { lock.unlock() }
            lock.lock()
            let oldState = _state
            switch (_state, newState) {
            case (.cancelled, _):
                break
            case (.finished, _):
                break
            default:
                willChangeValue(forKey: oldState.rawValue)
                willChangeValue(forKey: newState.rawValue)
                assert(_state != newState, "Performing invalid cyclic state transition.")
                _state = newState
                didChangeValue(forKey: oldState.rawValue)
                didChangeValue(forKey: newState.rawValue)
            }
        }
    }

    override open func start() {
        self.state = .executing
        self.execute()
    }

    override open func main() {
        self.state = .executing
        self.execute()
    }

    open func finish() {
        self.state = .finished
    }

    open func execute() {
        abstractMethod()
    }

    override open func cancel() {
        self.state = .cancelled
    }

    override open var isReady: Bool {
        return state == .ready
    }

    override open var isExecuting: Bool {
        return self.state == .executing
    }

    override open var isCancelled: Bool {
        return self.state == .cancelled
    }

    override open var isFinished: Bool {
        return self.state == .finished
    }
}
