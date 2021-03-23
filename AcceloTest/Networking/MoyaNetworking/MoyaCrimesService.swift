//
//  MoyaCrimesEndPoints.swift
//  AcceloTest
//
//  Created by Serhii Semenov on 14.08.2020.
//  Copyright © 2020 Serhii Semenov. All rights reserved.
//

import Foundation
import Moya

enum MoyaCrimesService {
    
    case getCrimesAtLocation(SearchedLocation)
}

extension MoyaCrimesService: TargetType {
    
    public var baseURL: URL {
        return URL(string: MoyaCrimesServiceConstants.url)!
    }
    
    public var path: String {
        switch self {
        case .getCrimesAtLocation:
            return MoyaCrimesServiceConstants.crimesPath
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getCrimesAtLocation:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getCrimesAtLocation(let searchedLocation):
            return .requestParameters(parameters: ["lat": searchedLocation.latitude,
                                                   "lng": searchedLocation.Longitude,
                                                   "date": searchedLocation.date],
                                      encoding: URLEncoding.default)
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .getCrimesAtLocation:
            return Data()
        }
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
