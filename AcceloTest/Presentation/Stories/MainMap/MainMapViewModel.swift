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

        DataService.shared.loadCrimesAtLocation(moyaProvider: provider, searchedLocation: searchedLocation)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .catchError{ error -> Observable<[Crime]> in
                self.alertWithMessage.accept(error.localizedDescription)
                return Observable.empty()
            }
            .map { Array($0.prefix(5)) }
            .bind(to: crimes)
            .disposed(by: disposeBag)
    }
}
