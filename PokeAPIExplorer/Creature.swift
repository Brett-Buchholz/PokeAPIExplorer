//
//  Creature.swift
//  CatchEmAll
//
//  Created by Brett Buchholz on 10/15/24.
//

import Foundation

struct Creature: Codable, Identifiable {
    let id: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
        self.id = url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        id = url
    }
}
