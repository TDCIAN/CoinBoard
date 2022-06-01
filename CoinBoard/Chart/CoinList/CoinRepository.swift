//
//  CoinRepository.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/15.
//

import Foundation
import Alamofire

protocol CoinNetwork: AnyObject {
    func requestCoinList(completion: @escaping (Result<[Coin], Error>) -> Void)
}

class CoinRepository: CoinNetwork {
    func requestCoinList(completion: @escaping (Result<[Coin], Error>) -> Void) {
        let coinList = CoinType.allCases.map { $0.rawValue }.joined(separator: ",")
        let param:RequestParam =
            .url([
                "fsyms": coinList,
                "tsyms": "USD,KRW"
            ])
        guard let coinListURL = CoinListRequest(param: param).urlRequest()?.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        AF.request(coinListURL).responseData { response in
            switch response.result {
            case .success(let successData):
                let decoder = JSONDecoder()
                do {
                    let coinListProcessedData = try decoder.decode(CoinListResponse.self, from: successData)
                    completion(.success(coinListProcessedData.raw.allCoins()))
                } catch {
                    completion(.failure(URLError(.cannotParseResponse)))
                    Log("==> coin list success catch error: \(error.localizedDescription)")
                }
            case .failure(let error):
                completion(.failure(URLError(.cannotLoadFromNetwork)))
                Log("==> coin list error: \(error.localizedDescription)")
            }
        }
    }
}
