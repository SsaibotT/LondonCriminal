//
//  DataStorage.swift
//  AcceloTest
//
//  Created by Serhii Semenov on 14.08.2020.
//  Copyright © 2020 Serhii Semenov. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import Alamofire

final class DataService {
    
    private init() {}
    
    static let shared = DataService()
    private let disposeBag = DisposeBag()
    
    func loadCrimesAtLocation(moyaProvider: MoyaProvider<MoyaCrimesService>,
                              searchedLocation: SearchedLocation,
                              completion: @escaping ((Crimes?, Error?) -> Void)) {
        
        moyaProvider.request(.getCrimesAtLocation(searchedLocation)) { result in
            
            switch result {
            case let .success(response):
                do {
                    let crimes = try response.map(Crimes.self)
                    completion(crimes, nil)
                } catch {
                    print("\(error)")
                }
                break
            case let .failure(error):
                completion(nil, error)
                break
            }
        }
    }
}
