//
//  CoinData.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/04.
//

import Foundation

//https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,DASH,LTC,ETC,XRP,BCH,XMR,QTUM,ZEC&tsyms=USD

enum CoinType: String, CaseIterable {
//    case BTC
//    case ETH
//    case DASH
//    case LTC
//    case ETC
//    case XRP
//    case BCH
//    case XMR
//    case QTUM
//    case ZEC
//    case BTG
    
    case BTC
    case ETH
    case ADA
    case XRP
    case LTC
    case LINK
    case XLM
    case BCH
    case BSV
    case EOS
    case TRX
    
    // BTC,ETH,ADA,XRP,LTC,LINK,XLM,BCH,BSV,EOS,TRX
}

struct CoinListResponse: Codable {
    let raw: RAWData
    enum CodingKeys: String, CodingKey {
        case raw = "RAW"
    }
}

struct RAWData: Codable {
//    let btc: Coin
//    let eth: Coin
//    // ---
//    let dash: Coin
//    let ltc: Coin
//    let etc: Coin
//    let xrp: Coin
//    let bch: Coin
//    let xmr: Coin
//    let qtum: Coin
//    let zec: Coin
//    let btg: Coin
    
    let btc: Coin
    let eth: Coin
    let ada: Coin
    let xrp: Coin
    let ltc: Coin
    let link: Coin
    let xlm: Coin
    let bch: Coin
    let bsv: Coin
    let eos: Coin
    let trx: Coin
    
    enum CodingKeys: String, CodingKey {
//        case btc = "BTC"
//        case eth = "ETH"
//        // ---
//        case dash = "DASH"
//        case ltc = "LTC"
//        case etc = "ETC"
//        case xrp = "XRP"
//        case bch = "BCH"
//        case xmr = "XMR"
//        case qtum = "QTUM"
//        case zec = "ZEC"
//        case btg = "BTG"
        
        case btc = "BTC"
        case eth = "ETH"
        case ada = "ADA"
        case xrp = "XRP"
        case ltc = "LTC"
        case link = "LINK"
        case xlm = "XLM"
        case bch = "BCH"
        case bsv = "BSV"
        case eos = "EOS"
        case trx = "TRX"
    }
}

extension RAWData {
    func allCoins() -> [Coin] {
//        return [btc, eth, dash, ltc, etc, xrp, bch, xmr, qtum, zec, btg]
        return [btc, eth, ada, xrp, ltc, link, xlm, bch, bsv, eos, trx]
    }
}

struct Coin: Codable {
    let usd: CurrencyInfo
    let krw: CurrencyInfo
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case krw = "KRW"
    }
}

struct CurrencyInfo: Codable {
    let price: Double
    let changeLast24H: Double
    let changePercentLast24H: Double
    let market: String
    let marketCapitalization: Double
    
    enum CodingKeys: String, CodingKey {
        case price = "PRICE"
        case changeLast24H = "CHANGE24HOUR"
        case changePercentLast24H = "CHANGEPCT24HOUR"
        case market = "LASTMARKET"
        case marketCapitalization = "MKTCAP"
    }
}

