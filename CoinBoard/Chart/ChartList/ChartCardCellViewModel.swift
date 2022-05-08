//
//  ChartCardCellViewModel.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/05.
//

import UIKit
import RxSwift
import Charts

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
    }
}

extension ChartCardCellViewModel {
    func loadChartData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        NetworkManager.requestCoinChartData(coinType: coinInfo.key, period: selectedPeriod) { result in
            dispatchGroup.leave()
            switch result {
            case .success(let coinChartDatas):
                self.chartDatas.append(CoinChartInfo(key: Period.week, value: coinChartDatas))
            case .failure(let error):
                Log("--> Card cell fetch data error: \(error.localizedDescription)")
            }
        }
        dispatchGroup.notify(queue: .main) {
            Log("--> Card cell에서 차트 렌더: \(self.chartDatas.count)")
            self.changeHandler(self.chartDatas, self.selectedPeriod)
        }
    }
    
    func updateNotify(handler: @escaping Handler) {
        self.changeHandler = handler
    }
}
