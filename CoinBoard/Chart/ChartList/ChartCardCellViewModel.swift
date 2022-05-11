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

typealias ChartViewSource = (chartViewData: [CoinChartInfo], period: Period)

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
    var chartDatas: [CoinChartInfo] = []
    var selectedPeriod: Period = .day
    
    let chartService = ChartService()
    
    init(
        coinInfo: CoinModel, // 콜렉션뷰에서 줌
        chartDatas: [CoinChartInfo],
        periodType: Int // 콜렉션뷰에서 줌
    ) {
        print("차트카드셀뷰모델 - 이닛 - 코인인포: \(coinInfo.key), 피리어드타입: \(periodType)")
        self.coinInfo = coinInfo
        self.chartDatas = chartDatas
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
        
        loadChartData(coinType: self.coinInfo.key, period: self.selectedPeriod)
        fetchChartList(coinType: self.coinInfo.key, period: self.selectedPeriod)
    }
}

extension ChartCardCellViewModel {
    func loadChartData(coinType: CoinType, period: Period) {
        print("차트카드셀뷰모델 - 로드차트 - 코인타입: \(coinType), 피리어드: \(period)")
        DispatchQueue.global().async {
            NetworkManager.requestCoinChartData(coinType: coinType, period: period) { result in
                switch result {
                case .success(let coinChartDatas):
                    self.chartDatas.append(CoinChartInfo(key: Period.week, value: coinChartDatas))
                    self.chartViewSource.accept(
                        ChartViewSource(
                            chartViewData: self.chartDatas,
                            period: self.selectedPeriod
                        )
                    )
                case .failure(let error):
                    Log("--> Card cell fetch data error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchChartList(coinType: CoinType, period: Period) {
        chartService.fetchChartList(coinType: coinType, period: period) { chartModels in
            print("차트모델스 카운트: \(chartModels.count)")
        }
    }
}
