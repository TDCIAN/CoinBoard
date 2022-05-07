//
//  NewsViewController.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/03.
//

import UIKit
import SafariServices
import RxSwift
import RxCocoa

class NewsViewController: UIViewController {
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet var newsTableView: UITableView!
    
    let disposeBag = DisposeBag()
    let viewModel = NewsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        viewModel.loadNews()
        
        viewModel.newsListCellData
            .asDriver(onErrorJustReturn: [])
            .drive(
                newsTableView.rx.items(
                    cellIdentifier: NewsListCell.identifier,
                    cellType: NewsListCell.self
                )
            ) { _, data, cell in
                cell.configCell(article: data)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(
            newsTableView.rx.modelSelected(NewsModel.self),
            newsTableView.rx.itemSelected
        )
        .bind { [weak self] news, indexPath in
            guard let self = self else { return }
            self.newsTableView.deselectRow(at: indexPath, animated: true)
            guard let url = URL(string: news.urlToImage) else {
                self.viewModel.presentFailedToOpenAlert { alert in
                    self.present(alert, animated: true)
                }
                return
            }
            self.viewModel.openSafari(url: url) { safari in
                self.present(safari, animated: true)
            }
        }
        .disposed(by: disposeBag)
    }
}
