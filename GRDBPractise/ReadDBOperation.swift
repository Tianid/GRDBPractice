//
//  GRDBOperation.swift
//  GRDBPractise
//
//  Created by Tianid on 25.05.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import Foundation
import GRDB

class ReadDBOperation<T: DatabaseWriter>: AsyncOperation {
    
    var columnElement: String
    var result: [Test_table]!
    var dbQP: T
    
    init(columnElement: String, dbQP: T) {
        self.columnElement = columnElement
        self.dbQP = dbQP
    }
    
    override func main() {
        read { [unowned self] (result) in
            self.result = result
            self.finish()
        }
    }
    
    
    
    func read(complition: @escaping ([Test_table]) -> Void) {
        try? dbQP.read { [unowned self] db in
            let result: [Test_table] = try Test_table.filter(Column("name") == self.columnElement).fetchAll(db)
            sleep(2)
            complition(result)
        }
    }
    
    
//    private func setupDatabase() {
//        let databaseURL = try! FileManager.default
//            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            .appendingPathComponent("db.sqlite")
//
//        dbPool = try! DatabasePool(path: databaseURL.absoluteString)
//
//    }
}
