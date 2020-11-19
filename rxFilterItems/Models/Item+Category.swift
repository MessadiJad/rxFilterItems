//
//  Item+Category.swift
//  rxFilterItems
//
//  Created by Jad Messadi on 11/16/20.
//

import Foundation

struct Category: Codable {
    let id : Int
    let type : String
    var isSelected : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
    }
}

struct ListCategories: Codable {
    let categories:[Category]
}

extension ListCategories {
    static var all: Resource<ListCategories> = {
        return Resource(url: Bundle.main.url(forResource: "categories", withExtension: "json")!)
    }()
}

struct Item : Codable{
    let id : Int
    let title : String
    let description : String
    let categoryId : Int
}

struct ListItems:Codable {
    let items:[Item]
}

extension ListItems {
    static var all: Resource<ListItems> = {
        return Resource(url: Bundle.main.url(forResource: "items", withExtension: "json")!)
    }()
}
