//
//  NetworkManager.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/04.
//

import Foundation
import Alamofire

class NetworkManager {
    static func requestCoinList(completion: @escaping (Result<[Coin], Error>) -> Void) {
        let param:RequestParam = .url(["fsyms":"BTC,ETH,DASH,LTC,ETC,XRP,BCH,XMR,QTUM,ZEC,BTG","tsyms":"USD"])
        guard let coinListURL = CoinListRequest(param: param).urlRequest()?.url else { return }
        // MARK: 이거 responseJSON 대신 쓸 수 있는지 확인해보자 -> JSONSerialization 필요 없어지나?
//        AF.request(coinListURL).responseData(completionHandler: )
        AF.request(coinListURL).responseJSON { response in
            switch response.result {
            case .success(let successData):
                let decoder = JSONDecoder()
                do {
                    let coinListRawData = try JSONSerialization.data(withJSONObject: successData, options: .prettyPrinted)
                    let coinListProcessedData = try decoder.decode(CoinListResponse.self, from: coinListRawData)
                    completion(.success(coinListProcessedData.raw.allCoins()))
                } catch let error {
                    print("--> coin list decoding error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("--> coin list error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    static func requestCoinChartData(coinType: CoinType, period: Period, completion: @escaping (Result<[ChartData], Error>) -> Void) {
        let param: RequestParam = .url(["fsym":"\(coinType.rawValue)",
                                        "tsym":"USD",
                                        "limit":"\(period.limitParameter)",
                                        "aggregate":"\(period.aggregateParameter)"])
        guard let coinChartDataURL = CoinChartDataRequest(period: .day, param: param).urlRequest()?.url else { return }
        AF.request(coinChartDataURL).responseJSON { response in
            switch response.result {
            case .success(let successData):
                let decoder = JSONDecoder()
                do {
                    let coinChartRawData = try JSONSerialization.data(withJSONObject: successData, options: .prettyPrinted)
                    let coinChartProcessedData = try decoder.decode(ChartDataResponse.self, from: coinChartRawData)
                    completion(.success(coinChartProcessedData.chartDatas))
                } catch let error {
                    print("--> coin chart decoding error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("--> coin chart error: \(error.localizedDescription)")
            }
        }
    }
    
    static func requestNewsList(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let newsURL = NewsListRequest().urlRequest()?.url else { return }
        AF.request(newsURL).responseJSON { response in
            switch response.result {
            case .success(let successData):
                let decoder = JSONDecoder()
                do {
                    let newsListRawData = try JSONSerialization.data(withJSONObject: successData, options: .prettyPrinted)
                    let newsListProcessedData = try decoder.decode([NewsResponse].self, from: newsListRawData)
                    completion(.success(newsListProcessedData.flatMap { $0.articleArray }))
                } catch let error {
                    print("--> news list decoding error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("--> news list error: \(error.localizedDescription)")
            }
        }
    }
}
