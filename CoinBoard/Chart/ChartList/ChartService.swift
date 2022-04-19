//
//  ChartService.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/18.
//

import Foundation

class ChartService {
    let coinType: CoinType
    let period: Period
    
    let repository = ChartRepository()
    
    var chartModelList: [ChartModel] = []
    
    init(coinType: CoinType, period: Period) {
        self.coinType = coinType
        self.period = period
    }
    
    func fetchChartList(onCompleted: @escaping ([ChartModel]) -> Void) {
        repository.requestCoinChartData(
            coinType: coinType,
            period: period) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let chartDatas):
                    Log("차트데이터스: \(chartDatas)")
                case .failure(let error):
                    Log("ChartService - fetchChartList - error: \(error)")
                }
            }
    }
    
}
