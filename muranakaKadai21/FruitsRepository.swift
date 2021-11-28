//
//  FruitsRepository.swift
//  muranakaKadai19
//
//  Created by 村中令 on 2021/11/21

import UIKit

class FruitsRepository {
    private let keyFruits = "fruits"
    
    func setFruits(fruits: [Fruit]) {
        let data = try? JSONEncoder().encode(fruits.map { FruitDTO(fruit: $0) })
        UserDefaults.standard.set(data, forKey: keyFruits)
    }

    func readFruits() -> [Fruit]? {
        let data = UserDefaults.standard.data(forKey: keyFruits)
        guard let data = data else { return nil }
        guard let persons = try? JSONDecoder().decode(Array<FruitDTO>.self, from: data) else {
            return nil
        }
        return persons.map { $0.fruit }
    }
}

private struct FruitDTO: Codable {
    var name: String
    var isCheck: Bool
    
    init(fruit: Fruit) {
        name = fruit.name
        isCheck = fruit.isCheck
    }
    
    var fruit: Fruit {
        .init(name: name, isCheck: isCheck)
    }
}
