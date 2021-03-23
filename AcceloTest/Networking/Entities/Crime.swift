//
//  Crimes.swift
//  AcceloTest
//
//  Created by Serhii Semenov on 14.08.2020.
//  Copyright © 2020 Serhii Semenov. All rights reserved.
//

import Foundation

typealias Crimes = [Crime]

struct Crime: Codable {
    
    let category: String
    let location: Location
}




