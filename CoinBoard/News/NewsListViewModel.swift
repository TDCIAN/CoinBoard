//
//  NewsListViewModel.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/05.
//

import Foundation
import RxSwift
import RxCocoa

class NewsListViewModel {
    let disposeBag = DisposeBag()
    
    let newsListCellData = BehaviorRelay<[NewsModel]>(value: [])
    
    let newsService = NewsService()
    
    func loadNews() {
        newsService.fetchNow { [weak self] newsModels in
            guard let self = self else { return }
            self.newsListCellData.accept(newsModels)
        }
    }
}
