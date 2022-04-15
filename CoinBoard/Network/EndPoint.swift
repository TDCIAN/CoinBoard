//
//  EndPoint.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/04.
//

import Foundation

// 3개의 네트워크 요청 URL
enum EndPoint {
    static let coinList: String = "https://min-api.cryptocompare.com/data/"
    static let coinChartData: String = "https://min-api.cryptocompare.com/data/"
//    static let newsList: String = "http://coinbelly.com/api/get_rss"
    static let newsList: String = "https://newsapi.org/v2/everything"
}
