//
//  CoinService.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/15.
//

import Foundation

class CoinService {
    let repository = CoinRepository()
    
    var currentModel: [CoinModel] = []
    
    func fetchNow(onCompleted: @escaping ([CoinModel]) -> Void) {
        // Entity -> Model
        repository.requestCoinList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let coins):
                let tuples = zip(CoinType.allCases, coins).map { CoinModel(key: $0, value: $1) }
                let sorted = tuples.sorted(by: {
                    ($0.value.krw.marketCapitalization ?? 0.0) > ($1.value.krw.marketCapitalization ?? 0.0)
                })
                self.currentModel = sorted
                onCompleted(self.currentModel)
            case .failure(let error):
                Log("CoinService - fetchNow - error: \(error)")
            }
        }
    }
}
