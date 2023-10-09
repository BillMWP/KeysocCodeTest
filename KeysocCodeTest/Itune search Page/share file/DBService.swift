//
//  DBService.swift
//  KeysocCodeTest
//
//  Created by BillBill on 8/10/2023.
//

import Foundation
import Realm
import RealmSwift

class DBService {
    var database: Realm
    static let shared = DBService()
    
    private init() {
        self.database = try! Realm()
    }
    
    func addData(model: Object) {
        try! self.database.write {
            self.database.add(model, update: .all)
        }
    }
    
    func getData<T: Object>(object: T.Type) -> Results<T>{
        return self.database.objects(object)
    }
    
    //get all data from target object type, delete one 
    func deleteData<T: Object>(object: T.Type, query: @escaping ((T) -> Bool)) {
        let objects = self.getData(object: object.self)
        let target = objects.first(where: {query($0)})
        try! self.database.write{
            if let target = target{
                self.database.delete(target)
            }
        }
    }
}
