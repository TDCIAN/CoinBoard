//
//  NewsListRequest.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/04.
//

import Foundation

struct NewsListRequest: Request {
    var method: HTTPMethod = .get
    var params: RequestParam
    var path: String { return EndPoint.newsList }
    
    init(param: RequestParam = .url([:])) {
        self.params = param
    }
}
