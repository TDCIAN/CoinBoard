//
//  ChartCardCellViewModel.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/05.
//

import UIKit
import RxSwift
import Charts
import RxRelay

class ChartCardCellViewModel {
    private let disposeBag = DisposeBag()

    var coinName: Observable<String> {
        return Observable<String>
            .just(coinInfo.key.rawValue)
    }
    
    var periodString: Observable<String> {
        return Observable<String>
            .just("Last \(selectedPeriod.rawValue)")
    }
    
    let chartViewSource = PublishRelay<ChartViewSource>()
    
    var coinInfo: CoinModel!
    var selectedPeriod: Period = .day
    
    let chartService = ChartService()
    
    init(
        coinInfo: CoinModel, // 콜렉션뷰에서 줌
        periodType: Int // 콜렉션뷰에서 줌
    ) {
        self.coinInfo = coinInfo
        switch periodType {
        case 0:
            self.selectedPeriod = .day
        case 1:
            self.selectedPeriod = .week
        case 2:
            self.selectedPeriod = .month
        case 3:
            self.selectedPeriod = .year
        default:
            self.selectedPeriod = .day
        }

        fetchChartViewSource(coinType: self.coinInfo.key, period: self.selectedPeriod)
    }
}

extension ChartCardCellViewModel {
    func fetchChartViewSource(coinType: CoinType, period: Period) {
        chartService.fetchChartList(coinType: coinType, period: period) { chartModels in
            self.chartViewSource.accept(
                ChartViewSource(
                    period: self.selectedPeriod,
                    chartModels: chartModels
                )
            )
        }
    }
}
