//
//  ChartRepository.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/18.
//

import Foundation
import Alamofire

protocol ChartNetwork: AnyObject {
    func requestCoinChartData(
        coinType: CoinType,
        period: Period,
        completion: @escaping (Result<[ChartData], Error>
        ) -> Void)
}

class ChartRepository: ChartNetwork {
    func requestCoinChartData(
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
}
