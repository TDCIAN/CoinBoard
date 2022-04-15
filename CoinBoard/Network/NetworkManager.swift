//
//  NetworkManager.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/04.
//

import Foundation
import Alamofire

protocol NetworkService {
    static func requestCoinList(completion: @escaping (Result<[Coin], Error>) -> Void)
    
    static func requestCoinChartData(
        coinType: CoinType,
        period: Period,
        completion: @escaping (Result<[ChartData], Error>
        ) -> Void)
    
    static func requestNewsList(completion: @escaping (Result<[Article], Error>) -> Void)
}

//class NetworkManager: NetworkService {

class NetworkManager {
    static func requestCoinList(completion: @escaping (Result<[Coin], Error>) -> Void) {
        let coinList = CoinType.allCases.map { $0.rawValue }.joined(separator: ",")
        let param:RequestParam =
            .url([
                "fsyms": coinList,
                "tsyms": "USD,KRW"
            ])
        guard let coinListURL = CoinListRequest(param: param).urlRequest()?.url else { return }
        AF.request(coinListURL).responseData { response in
            switch response.result {
            case .success(let successData):
                let decoder = JSONDecoder()
                do {
                    let coinListProcessedData = try decoder.decode(CoinListResponse.self, from: successData)
                    completion(.success(coinListProcessedData.raw.allCoins()))
                } catch {
                    Log("==> coin list success catch error: \(error.localizedDescription)")
                }
            case .failure(let error):
                Log("==> coin list error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    static func requestCoinChartData(
        coinType: CoinType,
        period: Period,
        completion: @escaping (Result<[ChartData], Error>
        ) -> Void) {
        let param: RequestParam = .url(["fsym":"\(coinType.rawValue)",
                                        "tsym":"USD",
                                        "limit":"\(period.limitParameter)",
                                        "aggregate":"\(period.aggregateParameter)"])
        guard let coinChartDataURL = CoinChartDataRequest(
            period: period,
            param: param
        ).urlRequest()?.url else { return }
        AF.request(coinChartDataURL).responseData { response in
            switch response.result {
            case .success(let successData):
                let decoder = JSONDecoder()
                do {
                    let coinChartProcessedData = try decoder.decode(ChartDataResponse.self, from: successData)
                    completion(.success(coinChartProcessedData.chartDatas))
                } catch let error {
                    Log("==> coin chart catch error: \(error.localizedDescription)")
                }
            case .failure(let error):
                Log("==> coin chart error: \(error.localizedDescription)")
            }
        }
    }
    
//    static func requestNewsList(completion: @escaping (Result<[Article], Error>) -> Void) {
//        let param: RequestParam = .url([
//            "q": "crypto",
//            "apiKey": "6d61b0036eb24a718896dca571428bc2"
//        ])
//        guard let newsURL = NewsListRequest(param: param).urlRequest()?.url else { return }
//
//        AF.request(newsURL).responseData { response in
//            switch response.result {
//            case .success(let successData):
//                let decoder = JSONDecoder()
//                do {
//                    let newsListProcessedData = try decoder.decode(ArticleResponse.self, from: successData)
//                    completion(.success(newsListProcessedData.articles))
//                } catch let error {
//                    Log("==> news list catch error: \(error.localizedDescription)")
//                }
//            case .failure(let error):
//                Log("==> news list error: \(error.localizedDescription)")
//            }
//        }
//    }
}
