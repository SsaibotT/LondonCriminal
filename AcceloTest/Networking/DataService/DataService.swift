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
                              searchedLocation: SearchedLocation) -> Observable<Crimes> {
        
        return Observable<Crimes>.create { [unowned self] observer in

            moyaProvider.rx.request(.getCrimesAtLocation(searchedLocation))
                .map(Crimes.self)
                .subscribe { crimes in
                    observer.onNext(crimes)
                    observer.onCompleted()
                } onError: { error in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
}
