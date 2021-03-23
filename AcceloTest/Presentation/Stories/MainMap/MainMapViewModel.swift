//
//  MainMapViewModel.swift
//  AcceloTest
//
//  Created by Serhii Semenov on 14.08.2020.
//  Copyright © 2020 Serhii Semenov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Alamofire

struct MainMapViewModel {
    
    // MARK: - Outputs
    let crimes = BehaviorRelay<Crimes>(value: [])
    let alertWithMessage = PublishRelay<String>()
    
    // MARK: - Properties
    private var provider = MoyaProvider<MoyaCrimesService>()
    private var disposeBag = DisposeBag()
    
    // MARK: - Internal
    func getCrimesAt(searchedLocation: SearchedLocation) {

        DataService.shared
            .loadCrimesAtLocation(moyaProvider: provider, searchedLocation: searchedLocation) { crimes, error in
                
                let task = DispatchWorkItem {
                    if let error = error {
                        self.alertWithMessage.accept(error.localizedDescription)
                    } else if let crimes = crimes {
                        self.crimes.accept(self.appendFiveElements(crimes: crimes))
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: task)
        }
    }
    
    // MARK: - Functions
    private func appendFiveElements(crimes: Crimes) -> Crimes {
        
        var tmpCrimes = Crimes()

        for (index, crime) in crimes.enumerated() {

            tmpCrimes.append(crime)
            if index == 4 { break }
        }

        return tmpCrimes
    }
}
