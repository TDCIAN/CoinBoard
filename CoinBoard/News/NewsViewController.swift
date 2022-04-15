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
                self.presentFailedToOpenAlert()
                return
            }
            self.open(url: url)
        }
        .disposed(by: disposeBag)
    }
    
    private func open(url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func presentFailedToOpenAlert() {
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
        present(alert, animated: true)
    }
}
