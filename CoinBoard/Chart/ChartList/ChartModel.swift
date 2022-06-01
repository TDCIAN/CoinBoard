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

enum Period: String, CaseIterable {
    case day = "24H"
    case week = "1 Week"
    case month = "1 Month"
    case year = "1 Year"
    
    var urlPath: String {
        switch self {
        case .day, .week:
            return "histohour"
        default:
            return "histoday"
        }
    }
    
    var limitParameter: Int {
        switch self {
        case .day: // hour
            return 24
        case .week: // (24 * 7 ) / aggreagte factor -> 1주일치인데 모아서 2로 나눈다
            return 7 * 24 / 2
        case .month:
            return 30 / 1
        case .year: // day / aggreagte factor -> 1년치를 모아서 10으로 나눈다
            return 365 / 10
        }
    }
    
    var aggregateParameter: Int {
        switch self {
        case .day:
            return 1
        case .week:
            return 2
        case .month:
            return 1
        case .year:
            return 10
        }
    }
}
