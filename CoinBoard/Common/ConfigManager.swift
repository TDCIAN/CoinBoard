//
//  ConfigManager.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/07.
//

import Foundation

class ConfigManager {
    static let getInstance = ConfigManager()
    
    var isDarkMode: Bool = false
    var currencyType: Int = 0
    var periodType: Int = 0
    
    init() {
        isDarkMode = UserDefaults.standard.bool(forKey: Constants.IS_DARK_MODE)
        currencyType = UserDefaults.standard.integer(forKey: Constants.CURRENCY_TYPE)
        periodType = UserDefaults.standard.integer(forKey: Constants.PERIOD_TYPE)
    }
}
