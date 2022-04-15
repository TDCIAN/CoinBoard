//
//  Repository.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/15.
//

import Foundation
import Alamofire

class NewsRepository {
    func requestNewsList(completion: @escaping (Result<[Article], Error>) -> Void) {
        let param: RequestParam = .url([
            "q": "crypto",
            "apiKey": "6d61b0036eb24a718896dca571428bc2"
        ])
        guard let newsURL = NewsListRequest(param: param).urlRequest()?.url else { return }

        AF.request(newsURL).responseData { response in
            switch response.result {
            case .success(let successData):
                let decoder = JSONDecoder()
                do {
                    let newsListProcessedData = try decoder.decode(ArticleResponse.self, from: successData)
                    completion(.success(newsListProcessedData.articles))
                } catch let error {
                    Log("==> news list catch error: \(error.localizedDescription)")
                }
            case .failure(let error):
                Log("==> news list error: \(error.localizedDescription)")
            }
        }
    }
}
