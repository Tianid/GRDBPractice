//
//  AsyncOperation.swift
//  GRDBPractise
//
//  Created by Tianid on 25.05.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import Foundation


class AsyncOperation: Operation {
    
    //MARK: - Properties
    private var _executing = false
    private var _finished = false
    
    //MARK: - Overrided properties
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    override var isFinished: Bool {
        return _finished
    }
    //MARK: - Overrided functions
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        willChangeValue(forKey: "isExecuting")
        _executing = true
        main()
        didChangeValue(forKey: "isExecuting")
    }
    
    override func cancel() {
        super.cancel()
        finish()
    }
    
    override func main() {
        fatalError("Should be overriden")
    }
    
    
    //MARK: - Functions
    func finish() {
        willChangeValue(forKey: "isFinished")
        _finished = true
        didChangeValue(forKey: "isFinisged")
    }
}
