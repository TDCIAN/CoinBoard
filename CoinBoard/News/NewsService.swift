//
//  Service.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/15.
//

import Foundation
import SafariServices

class NewsService {
    let repository = NewsRepository()
    
    var currentModel: [NewsModel] = []
    
    func fetchNewsList(onCompleted: @escaping ([NewsModel]) -> Void) {
        // Entity -> Model
        repository.requestNewsList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let articles):
                let mappedArticles: [NewsModel] = articles.map({ article in
                    var dateString: String {
                        let publishedAt = article.publishedAt ?? ""
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        dateFormatter.timeZone = .autoupdatingCurrent
                        let publishedDate: Date = dateFormatter.date(from: publishedAt) ?? Date()
                        return dateFormatter.string(from: publishedDate)
                    }
                    let newsModel = NewsModel(
                        title: article.title ?? "",
                        url: article.url ?? "",
                        urlToImage: article.urlToImage ?? "",
                        publishedAt: dateString
                    )
                    return newsModel
                })
                self.currentModel = mappedArticles
                onCompleted(self.currentModel)
            case .failure(let error):
                Log("NewsService - fetchNewsList - error: \(error)")
            }
        }
    }
}
