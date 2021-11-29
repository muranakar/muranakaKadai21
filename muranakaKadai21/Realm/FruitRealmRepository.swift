//
//  FruitRealmRepository.swift
//  muranakaKadai21
//
//  Created by 村中令 on 2021/11/27.
//

import Foundation
import RealmSwift

class FruitRealmRepository {

    enum Error: Swift.Error {
        case save
        case read
    }

    func save(fruits:[Fruit]) throws {
        do {
            let fruitsRealm = fruits.map{ FruitRealm(fruit: $0) }
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
                realm.add(fruitsRealm)
            }
        } catch {
            throw Error.save
        }
    }

    func read() throws -> [Fruit] {
        do {
            let realm = try Realm()
            let resultsFruitRealm = Array(realm.objects(FruitRealm.self))
            let results = resultsFruitRealm.map{ $0.fruit }
            return results
        } catch {
            throw Error.read
        }
    }
}
