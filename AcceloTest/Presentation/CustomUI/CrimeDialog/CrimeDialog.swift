//
//  CrimeDialog.swift
//  AcceloTest
//
//  Created by Serhii Semenov on 14.08.2020.
//  Copyright © 2020 Serhii Semenov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CrimeDialog: XibUIView {

    // MARK: - IBOutlets
    @IBOutlet weak var crimeCategoryLabel: UILabel!
    @IBOutlet weak var crimeLocationLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    var passingCloseButtonData: (() -> Void)?
    
    // MARK: - Init
    override func commonInit() {
        super.commonInit()
        
        self.configureRx()
    }
    
    // MARK: - ConfigureUI
    func configureView(crimeCategory: String, crimeLocation: String) {
        crimeCategoryLabel.text = crimeCategory
        crimeLocationLabel.text = crimeLocation
    }
    
    // MARK: - ConfigureRx
    private func configureRx() {
        
        closeButton.rx.tap
            .bind { [weak self] in self?.passingCloseButtonData?() }
            .disposed(by: disposeBag)
    }
}
