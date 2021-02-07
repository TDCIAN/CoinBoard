//
//  ChartListViewModel.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/05.
//

import UIKit

class ChartListViewModel {
    typealias Handler = ([CoinInfo]) -> Void
    var changeHandler: Handler
    
    var coinInfoList: [CoinInfo] = [] {
        didSet {
            changeHandler(coinInfoList)
        }
    }
    init(changeHandler: @escaping Handler) {
        self.changeHandler = changeHandler
    }
}

extension ChartListViewModel {
    func fetchData() {
        NetworkManager.requestCoinList { result in
            switch result {
            case .success(let coins):
                let tuples = zip(CoinType.allCases, coins).map { (key: $0, value: $1) }
                tuples.forEach {
                    print("그냥 튜플 코인 타입: \($0.key.rawValue), 시총: \($0.value.krw.marketCapitalization)")
                }
                
                let sorted = tuples.sorted(by: { $0.value.krw.marketCapitalization > $1.value.krw.marketCapitalization })
                sorted.forEach {
                    print("소트된 튜플 코인 타입: \($0.key.rawValue), 시총: \($0.value.krw.marketCapitalization)")
                }
                self.coinInfoList = sorted
            case .failure(let error):
                print("--> coin list error: \(error.localizedDescription)")
            }
        }
    }
    
    var numberOfCoinInfoList: Int {
        return coinInfoList.count
    }
    
    func cell(for indexPath: IndexPath, at tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartListCell", for: indexPath) as? ChartListCell else { return UITableViewCell()
        }
        let coinInfo = coinInfoList[indexPath.row]
        cell.configCell(coinInfo: coinInfo)
        return cell
    }
    
    func coinInfo(at indexPath: IndexPath) -> CoinInfo {
        let coinInfo = coinInfoList[indexPath.row]
        return coinInfo
    }
}
