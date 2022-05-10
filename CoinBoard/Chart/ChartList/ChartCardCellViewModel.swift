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
    
    var chartView: Observable<LineChartView> {
        return Observable<LineChartView>
            .just(LineChartView(frame: .zero))
    }
    
    let chartViewSource = PublishRelay<ChartViewSource>()
    
    typealias Handler = ([CoinChartInfo], Period) -> Void
    var changeHandler: Handler
    
//    var coinInfo: CoinInfo!
    var coinInfo: CoinModel!
    var chartDatas: [CoinChartInfo] = []
    var selectedPeriod: Period = .day
    
    init(
        coinInfo: CoinModel, // 콜렉션뷰에서 줌
        chartDatas: [CoinChartInfo],
        periodType: Int, // 콜렉션뷰에서 줌
        changeHandler: @escaping Handler
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
        self.changeHandler = changeHandler
        
        loadChartData(coinType: self.coinInfo.key, period: self.selectedPeriod)
    }
}

extension ChartCardCellViewModel {
    func loadChartData(coinType: CoinType, period: Period) {
        print("차트카드셀뷰모델 - 로드차트")
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        NetworkManager.requestCoinChartData(coinType: coinType, period: period) { result in
            dispatchGroup.leave()
            switch result {
            case .success(let coinChartDatas):
                self.chartDatas.append(CoinChartInfo(key: Period.week, value: coinChartDatas))
//                self.chartDatas.append(CoinChartInfo(key: period, value: coinChartDatas))
            case .failure(let error):
                Log("--> Card cell fetch data error: \(error.localizedDescription)")
            }
        }
        dispatchGroup.notify(queue: .main) {
            Log("--> Card cell에서 차트 렌더 - 코인타입: \(coinType), 피리어드: \(self.selectedPeriod)")
            self.chartViewSource.accept(
                ChartViewSource(
                    chartViewData: self.chartDatas,
                    period: self.selectedPeriod
                )
            )
//            self.changeHandler(self.chartDatas, self.selectedPeriod)
        }
    }
    
    func updateNotify(handler: @escaping Handler) {
        print("차트카드셀뷰모델 - 업데이트노티파이")
        self.changeHandler = handler
    }
}
