//
//  Entity.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/04/15.
//

import Foundation

struct ArticleResponse: Codable {
    let status: String?
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}
