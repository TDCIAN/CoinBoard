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
    
    func configCell(article: Article) {
        let url = URL(string: article.urlToImage ?? "")!
        thumbnail.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        newsTitle.text = article.title
        newsDate.text = article.publishedAt
        var dateString: String {
            let publishedAt = article.publishedAt ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = .autoupdatingCurrent
            let publishedDate: Date = dateFormatter.date(from: publishedAt) ?? Date()
            return dateFormatter.string(from: publishedDate)
        }
        newsDate.text = dateString
    }
}
