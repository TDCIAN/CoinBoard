//
//  ChartListCell.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/05.
//

import UIKit

class ChartListCell: UITableViewCell {
    @IBOutlet weak var currentStatusBox: UIView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var change24Hours: UILabel!
    @IBOutlet weak var changePercent: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var currentStatusImageView: UIImageView!
    
    func configCell(coinInfo: CoinInfo) {
        let coinType = coinInfo.key
        let coin = coinInfo.value
        let currentCurrency = UserDefaults.standard.integer(forKey: Constants.CURRENCY_TYPE)
        let currencyType = (currentCurrency == 0) ? coin.usd : coin.krw
        let isUnderPerform = (currencyType.changeLast24H ?? 0.0) < 0
        let upColor = UIColor.systemPink
        let downColor = UIColor.systemBlue
        let color = isUnderPerform ? downColor : upColor
        currentStatusBox.backgroundColor = color
        coinName.text = coinType.rawValue
        currency.text = (currentCurrency == 0) ? "USD" : "KRW"
        currentPrice.text = currencyType.price?.toNumberFormatted()
        change24Hours.text = String(format: "%.1f", currencyType.changeLast24H ?? 0.0)
        changePercent.text = String(format: "%.1f %%", currencyType.changePercentLast24H ?? 0.0)
        change24Hours.textColor = color
        changePercent.textColor = color
        
        let statusImage = isUnderPerform ? UIImage(systemName: "arrowtriangle.down.fill") : UIImage(systemName: "arrowtriangle.up.fill")
        currentStatusImageView.image = statusImage
        currentStatusImageView.tintColor = color
    }
}
