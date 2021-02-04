//
//  Period.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/04.
//

import Foundation

enum Period: String, CaseIterable {
    case day
    case week
    case month
    case year
    
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
