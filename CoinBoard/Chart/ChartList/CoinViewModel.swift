//
//  CoinViewModel.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/15.
//

import Foundation
import RxSwift
import RxCocoa

class CoinViewModel {
    let disposeBag = DisposeBag()
    
    let coinListCellData = BehaviorRelay<[CoinModel]>(value: [])
    
    let coinService = CoinService()
    
    func loadCoinList() {
        coinService.fetchCoinList { [weak self] coinModels in
            guard let self = self else { return }
            self.coinListCellData.accept(coinModels)
        }
    }
}
