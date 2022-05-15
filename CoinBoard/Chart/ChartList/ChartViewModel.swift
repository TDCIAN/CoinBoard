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

class ChartViewModel {
    private let disposeBag = DisposeBag()

    var coinName: Observable<String> {
        return Observable<String>
            .just(coinInfo.key.rawValue)
    }
    
    var periodString: Observable<String> {
        return Observable<String>
            .just("Last \(selectedPeriod.rawValue)")
    }
    
    var currencyType: Observable<String> {
        let currentCurrency = UserDefaults.standard.integer(forKey: Constants.CURRENCY_TYPE)
        return Observable<String>
            .just((currentCurrency == 0) ? "USD" : "KRW")
    }
    
    var currentPrice: Observable<String> {
        let currentCurrency = UserDefaults.standard.integer(forKey: Constants.CURRENCY_TYPE)
        let usdPrice: String = coinInfo.value.usd.price?.toNumberFormatted() ?? "-"
        let krwPrice: String = coinInfo.value.krw.price?.toNumberFormatted() ?? "-"
        return Observable<String>
            .just((currentCurrency == 0) ? usdPrice : krwPrice)
    }
    
    let chartViewSource = PublishRelay<ChartViewSource>()
    let chartViewSourceList = BehaviorRelay<[ChartViewSource]>(value: [])
    
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

extension ChartViewModel {
    func fetchChartViewSource(coinType: CoinType, period: Period) {
        chartService.fetchChartList(coinType: coinType, period: period) { chartModels in
            print("차트뷰모델 - 페치차트뷰소스 - 코인타입: \(coinType), 피리어드: \(period), 차트모델카운트: \(chartModels.count)")
            self.chartViewSource.accept(
                ChartViewSource(
                    period: self.selectedPeriod,
                    chartModels: chartModels
                )
            )
        }
    }
    
    func fetchChartViewSourceList() {
        Period.allCases.forEach { period in
            chartService.fetchChartList(coinType: self.coinInfo.key, period: period) { chartModels in
                var sourceListValue = self.chartViewSourceList.value
                let newChartViewSource: ChartViewSource = ChartViewSource(
                    period: period, chartModels: chartModels
                )
                print("차트뷰모델 - 페치차트뷰소스리스트 - 코인타입: \(self.coinInfo.key), 피리어드: \(period), 차트뷰소스리스트 카운트: \(self.chartViewSourceList.value.count)")
                
                sourceListValue.append(newChartViewSource)
                self.chartViewSourceList.accept(sourceListValue)
            }
        }
    }
}
