//
//  TestOperation.swift
//  GRDBPractise
//
//  Created by Tianid on 25.05.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import Foundation

class TestOperation: AsyncOperation {
    
    var lhs: Int
    var rhs: Int
    var result: Int?
    var someActionClass: SomeAction
    
    init(lhs: Int, rhs: Int, someActionClass: SomeAction) {
        self.lhs = lhs
        self.rhs = rhs
        self.someActionClass = someActionClass
    }
    
    override func main() {
//        sumElements(lhs: lhs, rhs: rhs) { [unowned self](result) in
//            self.result = result
//            self.finish()
//        }
        
        someActionClass.sumElements(lhs: lhs, rhs: rhs) { [unowned self](result) in
            self.result = result
            self.finish()
        }
        
    }
    
    
    private func sumElements(lhs: Int, rhs: Int, complition: @escaping (Int) -> Void ) {
        sleep(1)
        complition(lhs + rhs)
    }
}
