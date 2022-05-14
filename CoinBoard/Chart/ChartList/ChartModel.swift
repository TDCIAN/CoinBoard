//
//  ChartModel.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/18.
//

import Foundation

struct ChartViewSource {
    var period: Period
    var chartModels: [ChartModel]
}

struct ChartModel {
    var key: Period
    var value: [ChartData]
}
