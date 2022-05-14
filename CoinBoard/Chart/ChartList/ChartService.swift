//
//  ChartService.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/18.
//

import Foundation

class ChartService {
    let repository = ChartRepository()
    
    var chartModelList: [ChartModel] = []
    
    func fetchChartList(coinType: CoinType, period: Period, onCompleted: @escaping ([ChartModel]) -> Void) {
        repository.requestCoinChartData(
            coinType: coinType,
            period: period) { [weak self] result in
                switch result {
                case .success(let chartDatas):
                    self?.chartModelList.append(ChartModel(key: Period.week, value: chartDatas))
                    onCompleted(self?.chartModelList ?? [])
                case .failure(let error):
                    Log("ChartService - fetchChartList - error: \(error)")
                }
            }
    }
}
