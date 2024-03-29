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
        let param:RequestParam =
            .url(["fsyms":"BTC,ETH,ADA,XRP,LTC,LINK,XLM,BCH,BSV,EOS,TRX","tsyms":"USD,KRW"])
        guard let coinListURL = CoinListRequest(param: param).urlRequest()?.url else { return }
        AF.request(coinListURL).responseData { response in
            switch response.result {
            case .success(let successData):
                let decoder = JSONDecoder()
                do {
                    let coinListProcessedData = try decoder.decode(CoinListResponse.self, from: successData)
                    completion(.success(coinListProcessedData.raw.allCoins()))
                } catch {
                    
                }
            case .failure(let error):
                print("==> coin list catch error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    static func requestCoinChartData(coinType: CoinType, period: Period, completion: @escaping (Result<[ChartData], Error>) -> Void) {
        let param: RequestParam = .url(["fsym":"\(coinType.rawValue)",
                                        "tsym":"USD",
                                        "limit":"\(period.limitParameter)",
                                        "aggregate":"\(period.aggregateParameter)"])
        guard let coinChartDataURL = CoinChartDataRequest(period: period, param: param).urlRequest()?.url else { return }
        AF.request(coinChartDataURL).responseData { response in
            switch response.result {
            case .success(let successData):
                let decoder = JSONDecoder()
                do {
                    let coinChartProcessedData = try decoder.decode(ChartDataResponse.self, from: successData)
                    completion(.success(coinChartProcessedData.chartDatas))
                } catch let error {
                    print("==> coin chart catch error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("==> coin chart error: \(error.localizedDescription)")
            }
        }
    }
    
    static func requestNewsList(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let newsURL = NewsListRequest().urlRequest()?.url else { return }
//        AF.request(newsURL).responseJSON { response in
//            switch response.result {
//            case .success(let successData):
//                let decoder = JSONDecoder()
//                do {
//                    let newsListRawData = try JSONSerialization.data(withJSONObject: successData, options: .prettyPrinted)
//                    let newsListProcessedData = try decoder.decode([NewsResponse].self, from: newsListRawData)
//                    completion(.success(newsListProcessedData.flatMap { $0.articleArray }))
//                } catch let error {
//                    print("--> news list decoding error: \(error.localizedDescription)")
//                }
//            case .failure(let error):
//                print("--> news list error: \(error.localizedDescription)")
//            }
//        }
        AF.request(newsURL).responseData { response in
            switch response.result {
            case .success(let successData):
                let decoder = JSONDecoder()
                do {
                    let newsListProcessedData = try decoder.decode([NewsResponse].self, from: successData)
                    completion(.success(newsListProcessedData.flatMap { $0.articleArray }))
                } catch let error {
                    print("==> news list catch error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("==> news list error: \(error.localizedDescription)")
            }
        }
    }
}
