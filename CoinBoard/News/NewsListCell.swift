//
//  NewsListCell.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/05.
//

import UIKit
import Kingfisher

class NewsListCell: UITableViewCell {
    static let identifier = "NewsListCell"
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    
    func configCell(article: NewsModel) {
        let url = URL(string: article.urlToImage)!
        thumbnail.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        newsTitle.text = article.title
        newsDate.text = article.publishedAt
    }
}
