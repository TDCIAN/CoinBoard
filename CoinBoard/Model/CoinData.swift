//
//  CoinData.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/04.
//

import Foundation

enum CoinType: String, CaseIterable {
    case BTC
    case ETH
    case BNB
    case XRP
    case SOL
    
    case ADA
    case LUNA
    case AVAX
    case DOGE
    case DOT
    
    case SHIB
    case WBTC
    case NEAR
    case MATIC
    case CRO = "COIN"
    
    case LTC
    case ATOM
    case UNI
    case BCH
    case LINK
    
    case TRX
    case FTT
    case LEO
    case ETC
    case ALGO
    
    case XLM
    case XMR
    case VET
    case MANA
    case HBAR
    
    case ICP
    case FIL
    case APE
    case EGLD
    case ICX

}

struct CoinListResponse: Codable {
    let raw: RAWData
    enum CodingKeys: String, CodingKey {
        case raw = "RAW"
    }
}

struct RAWData: Codable {
    let btc: Coin
    let eth: Coin
    let bnb: Coin
    let xrp: Coin
    let sol: Coin
    
    let ada: Coin
    let luna: Coin
    let avax: Coin
    let doge: Coin
    let dot: Coin
    
    let shib: Coin
    let wbtc: Coin
    let near: Coin
    let matic: Coin
    let cro: Coin
    
    let ltc: Coin
    let atom: Coin
    let uni: Coin
    let bch: Coin
    let link: Coin
    
    let trx: Coin
    let ftt: Coin
    let leo: Coin
    let etc: Coin
    let algo: Coin
    
    let xlm: Coin
    let xmr: Coin
    let vet: Coin
    let mana: Coin
    let hbar: Coin
    
    let icp: Coin
    let fil: Coin
    let ape: Coin
    let egld: Coin
    let icx: Coin
    
    enum CodingKeys: String, CodingKey {
        case btc = "BTC"
        case eth = "ETH"
        case bnb = "BNB"
        case xrp = "XRP"
        case sol = "SOL"
        
        case ada = "ADA"
        case luna = "LUNA"
        case avax = "AVAX"
        case doge = "DOGE"
        case dot = "DOT"
        
        case shib = "SHIB"
        case wbtc = "WBTC"
        case near = "NEAR"
        case matic = "MATIC"
        case cro = "COIN"
        
        case ltc = "LTC"
        case atom = "ATOM"
        case uni = "UNI"
        case bch = "BCH"
        case link = "LINK"
        
        case trx = "TRX"
        case ftt = "FTT"
        case leo = "LEO"
        case etc = "ETC"
        case algo = "ALGO"
        
        case xlm = "XLM"
        case xmr = "XMR"
        case vet = "VET"
        case mana = "MANA"
        case hbar = "HBAR"
        
        case icp = "ICP"
        case fil = "FIL"
        case ape = "APE"
        case egld = "EGLD"
        case icx = "ICX"
    }
}

extension RAWData {
    func allCoins() -> [Coin] {
        return [
            btc, eth, bnb, xrp, sol,
            ada, luna, avax, doge, dot,
            shib, wbtc, near, matic, cro,
            ltc, atom, uni, bch, link,
            trx, ftt, leo, etc, algo,
            xlm, xmr, vet, mana, hbar,
            icp, fil, ape, egld, icx
        ]
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
    let price: Double?
    let changeLast24H: Double?
    let changePercentLast24H: Double?
    let market: String?
    let marketCapitalization: Double?
    
    enum CodingKeys: String, CodingKey {
        case price = "PRICE"
        case changeLast24H = "CHANGE24HOUR"
        case changePercentLast24H = "CHANGEPCT24HOUR"
        case market = "LASTMARKET"
        case marketCapitalization = "MKTCAP"
    }
}
