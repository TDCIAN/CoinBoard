//
//  CoinListRequest.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/04.
//

import Foundation

struct CoinListRequest: Request {
    var method: HTTPMethod = .get
    var params: RequestParam
    var path: String { return EndPoint.coinList + "pricemultiful" }
    
    init(param: RequestParam) {
        self.params = param
    }
}
