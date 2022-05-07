//
//  NewsListViewModel.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/05.
//

import Foundation
import SafariServices
import RxSwift
import RxCocoa

class NewsListViewModel {
    let newsListCellData = BehaviorRelay<[NewsModel]>(value: [])
    
    let newsService = NewsService()
    
    func loadNews() {
        newsService.fetchNewsList { [weak self] newsModels in
            guard let self = self else { return }
            self.newsListCellData.accept(newsModels)
        }
    }
    
    func openSafari(url: URL, completion: @escaping(SFSafariViewController) -> Void) {
        let vc = SFSafariViewController(url: url)
        completion(vc)
    }
    
    func presentFailedToOpenAlert(completion: @escaping(UIAlertController) -> Void) {
        let alert = UIAlertController(
            title: "Unable to Open",
            message: "We were unable to open the article.",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Dismiss",
                style: .cancel,
                handler: nil
            )
        )
        completion(alert)
    }
}
