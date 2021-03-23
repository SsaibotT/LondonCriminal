//
//  Location.swift
//  AcceloTest
//
//  Created by Serhii Semenov on 14.08.2020.
//  Copyright © 2020 Serhii Semenov. All rights reserved.
//

import Foundation

struct Location: Codable {
    
    let street: Street
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case street
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let latitude = try container.decode(String.self, forKey: .latitude)
        let longitude = try container.decode(String.self, forKey: .longitude)
        self.street = try container.decode(Street.self, forKey: .street)

        self.latitude  = Double(latitude) ?? 0.0
        self.longitude = Double(longitude) ?? 0.0
    }
}
