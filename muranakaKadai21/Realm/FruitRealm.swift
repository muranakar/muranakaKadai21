//
//  FruitRealm.swift
//  muranakaKadai21
//
//  Created by 村中令 on 2021/11/27.
//

import Foundation
import RealmSwift

class FruitRealm: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var isCheck: Bool = false

    convenience  init(fruit: Fruit) {
        self.init()
        self.name = fruit.name
        self.isCheck = fruit.isCheck
    }

    var fruit: Fruit {
        .init(name: name, isCheck: isCheck)
    }
}
