//
//  ProductTransaction.swift
//  Goods store
//
//  Created by Pavel Akulenak on 28.06.21.
//

import RealmSwift

class ProductTransaction: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var quantity: Int = 0
    @objc dynamic var price: Double = 0
    @objc dynamic var type: String = ""
    @objc dynamic var date: String = ""
}
