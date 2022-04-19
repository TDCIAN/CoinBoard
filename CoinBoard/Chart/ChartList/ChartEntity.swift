//
//  ChartEntity.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/18.
//

import Foundation

struct ChartDataResponse: Codable {
    let chartDatas: [ChartData]
    
    enum CodingKeys: String, CodingKey {
        case chartDatas = "Data"
    }
}

struct ChartData: Codable {
    let time: TimeInterval
    let closePrice: Double
    
    enum CodingKeys: String, CodingKey {
        case time
        case closePrice = "close"
    }
}
