//
//  ViewController.swift
//  GRDBPractise
//
//  Created by Tianid on 24.05.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import UIKit
import GRDB
//po NSHomeDirectory()




class ViewController: UIViewController {
    var dbQueue: DatabaseQueue!
    var dbPool: DatabasePool!
    var query = #"""
CREATE TABLE "Test_table" (
        "id"    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "name"    TEXT NOT NULL,
        "email"    TEXT NOT NULL
    );
"""#
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        asyncOperationTest()
        setupDatabase()
        //        multiQueueTest(db: dbPool) // dbQueue
        
        createTable()
        insertData(name: "kek", email: "kek@shmek.com")
        insertData(name: "DeleteMe", email: "DeleteMe@shmek.com")
        update(name: "lol")
        select()
        selectUesr()
        delete()
        // Do any additional setup after loading the view.
    }
    
    
    private func setupDatabase() {
        let databaseURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        dbQueue = try!  DatabaseQueue(path: databaseURL.absoluteString)
        var config = Configuration()
        config.readonly = true
        //        config.trace = { print($0)}
        config.maximumReaderCount = 5
        dbPool = try! DatabasePool(path: databaseURL.absoluteString, configuration: config)
        
    }
    
    private func createTable() {
        try? dbQueue.writeWithoutTransaction({ db in
            try db.execute(sql: query)
            try db.create(table: "GRDB", ifNotExists: true,  body: { table in
                table.column("testName", .text).notNull().defaults(sql: "asd")
                table.column("boolTest", .boolean).notNull().defaults(to: false)
                table.autoIncrementedPrimaryKey("id")
            })
            
        })
    }
    
    private func insertData(name: String, email: String) {
        do {
            try dbQueue.write({ db in
                try db.execute(sql: "INSERT INTO Test_table (name, email) VALUES (?, ?)",
                               arguments: [name, email])
                try Test_table(name: "Test", email: "test@test.test").insert(db)
                
                //            try UserThree(name: "TestThree", email: "testThree@asd.asd").insert(db)
                
            })
        } catch {
            print(error)
        }
        
    }
    
    private func update(name: String) {
        try? dbQueue.write { db in
            try db.execute(sql: "UPDATE Test_table SET name = :name WHERE id = :id",
                           arguments: ["name": name, "id": 1])
            
        }
    }
    
    private func select() {
        try? dbQueue.read { db in
            if let row = try Row.fetchOne(db, sql: "SELECT * FROM Test_table WHERE id = ?", arguments: [1]) {
                print(row)
            }
            
        }
    }
    
    private func selectUesr() {
        try? dbQueue.read { db in
            //            let users = try UserTwo.fetchAll(db, sql: "SELECT * FROM Test_table")
            let test_table = try Test_table.fetchAll(db)
            print(test_table)
        }
    }
    
    private func delete() {
        try? dbQueue.write { db in
            try Test_table.filter(Column("name") == "DeleteMe").deleteAll(db)
        }
    }
    
    
    
}

//struct Test_table: PersistableRecord {
//    func encode(to container: inout PersistenceContainer) {
//        container["id"] = id
//        container["name"] = name
//        container["email"] = email
//    }
//
//    let id: Int? = nil
//    let name: String
//    let email: String
//
//}

struct UserTwo: FetchableRecord {
    init(row: Row) {
        self.id = row["id"]
        self.name = row["name"]
        self.email = row["email"]
    }
    
    let id: Int
    let name: String
    let email: String
}


struct Test_table: FetchableRecord, PersistableRecord {
    internal init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    func encode(to container: inout PersistenceContainer) {
        container["name"] = name
        container["email"] = email
    }
    
    
    init(row: Row) {
        self.name = row["name"]
        self.email = row["email"]
    }
    
    let name: String
    let email: String
}



//MARK: Async operation test
class SomeAction {
    func sumElements(lhs: Int, rhs: Int, complition: @escaping (Int) -> Void ) {
        sleep(1)
        complition(lhs + rhs)
    }
}

func asyncOperationTest() {
    let operQueue = OperationQueue()
    let arr = [(1,2),(5,12),(38,4),(100,1),(90,1),(1000,20)]
    let someClass = SomeAction()
    for (lhs,rhs) in arr {
        let operation = TestOperation(lhs: lhs, rhs: rhs, someActionClass: someClass)
        operation.completionBlock = {
            guard let result = operation.result else { return }
            print("\(Date().timeIntervalSince1970)  \(lhs) + \(rhs) = \(result) ")
        }
        operQueue.addOperation(operation)
    }
}

func multiQueueTest<T: DatabaseWriter>(db: T) {
    let operQueue = OperationQueue()
    let opQ2 = OperationQueue()
    let opQ3 = OperationQueue()
    let arr = [ReadDBOperation<T>(columnElement: "DeleteMe", dbQP: db), ReadDBOperation(columnElement: "Test",dbQP: db), ReadDBOperation(columnElement: "kek",dbQP: db)]
    
    let arr2 = [ReadDBOperation<T>(columnElement: "DeleteMe", dbQP: db), ReadDBOperation(columnElement: "Test",dbQP: db), ReadDBOperation(columnElement: "kek",dbQP: db)]
    
    let arr3 = [ReadDBOperation<T>(columnElement: "DeleteMe", dbQP: db), ReadDBOperation(columnElement: "Test",dbQP: db), ReadDBOperation(columnElement: "kek",dbQP: db)]
    
    for item in arr {
        item.completionBlock = {
            guard let result = item.result else { return }
            print( "opQ1 - \(result)")
        }
        
        operQueue.addOperation(item)
    }
    
    for item in arr2 {
        item.completionBlock = {
            guard let result = item.result else { return }
            print("opQ2 - \(result)")
        }
        
        opQ2.addOperation(item)
    }
    
    for item in arr3 {
        item.completionBlock = {
            guard let result = item.result else { return }
            print("opQ3 - \(result)")
        }
        
        opQ3.addOperation(item)
    }
}
