//
//  SettingsViewModel.swift
//  CoinBoard
//
//  Created by JeongminKim on 2022/05/07.
//

import UIKit
import SafariServices
import RxSwift
import RxCocoa

class SettingsViewModel {
    func handleDarkmodeSwitch(isOn: Bool) {
        if isOn {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
            ConfigManager.getInstance.isDarkMode = true
            UserDefaults.standard.set(true, forKey: Constants.IS_DARK_MODE)
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
            ConfigManager.getInstance.isDarkMode = false
            UserDefaults.standard.set(false, forKey: Constants.IS_DARK_MODE)
        }
    }
    
    func handleCurrencySeg(selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            ConfigManager.getInstance.currencyType = 0
            UserDefaults.standard.set(0, forKey: Constants.CURRENCY_TYPE)
        case 1:
            ConfigManager.getInstance.currencyType = 1
            UserDefaults.standard.set(1, forKey: Constants.CURRENCY_TYPE)
        default:
            ConfigManager.getInstance.currencyType = 0
            UserDefaults.standard.set(0, forKey: Constants.CURRENCY_TYPE)
        }
    }
    
    func handlePeriodSeg(selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            UserDefaults.standard.set(0, forKey: Constants.PERIOD_TYPE)
        case 1:
            UserDefaults.standard.set(1, forKey: Constants.PERIOD_TYPE)
        case 2:
            UserDefaults.standard.set(2, forKey: Constants.PERIOD_TYPE)
        case 3:
            UserDefaults.standard.set(3, forKey: Constants.PERIOD_TYPE)
        default:
            UserDefaults.standard.set(0, forKey: Constants.PERIOD_TYPE)
        }
    }
    
    func tapPrivacyPolicyButton(completion: @escaping (SFSafariViewController) -> Void) {
        guard let privacyURL = URL(string: "https://app-privacy-policy.netlify.app/") else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safari = SFSafariViewController(url: privacyURL, configuration: config)
        safari.preferredBarTintColor = UIColor.white
        safari.preferredControlTintColor = UIColor.systemBlue
        
        completion(safari)
    }
}
