//
//  ChartViewModel.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/18.
//

import Foundation
import RxSwift
import RxCocoa

class ChartViewModel {
    let disposeBag = DisposeBag()
    let repository = ChartRepository()
                                               
    let chartDatas = BehaviorRelay<[ChartModel]>(value: [])
    
    func loadChartList(period: Period) {
        DispatchQueue.global().async {
            CoinType.allCases.forEach { coinType in
                Period.allCases.forEach { period in
                    self.repository.requestCoinChartData(coinType: coinType, period: period) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let coinChartDatas):
                            DispatchQueue.main.async {
                                self.chartDatas.accept([ChartModel(key: period, value: coinChartDatas)])
                                Log("차트뷰모델 - 차트데이터 개수: \(self.chartDatas.value.count)")
                            }
                        case .failure(let error):
                            Log("ChartViewModel - loadChartList fail - error: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func loadChartDetail(coinType: CoinType, period: Period = .week) {
        DispatchQueue.global().async {
            self.repository.requestCoinChartData(coinType: coinType, period: period) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let coinChartDatas):
                    DispatchQueue.main.async {
                        self.chartDatas.accept([ChartModel(key: period, value: coinChartDatas)])
                    }
                case .failure(let error):
                    Log("ChartViewModel - loadChartDetail fail - error: \(error)")
                }
            }
        }
    }
}
