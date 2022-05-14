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
    
    func fetchChartList(coinType: CoinType, period: Period, onCompleted: @escaping ([ChartData]) -> Void) {
        repository.requestCoinChartData(
            coinType: coinType,
            period: period) { [weak self] result in
                switch result {
                case .success(let chartDatas):
                    onCompleted(chartDatas)
//                    Log("차트데이터스 이거 맞나: \(chartDatas)")
                case .failure(let error):
                    Log("ChartService - fetchChartList - error: \(error)")
                }
            }
    }
    
}
