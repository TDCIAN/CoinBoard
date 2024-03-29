//
//  SettingViewController.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/03.
//

import UIKit
import SafariServices

class SettingsViewController: UITableViewController {

    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var currencySegmented: UISegmentedControl!
    @IBOutlet weak var periodSegmented: UISegmentedControl!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addTarget()
    }
    func setupView() {
        darkModeSwitch.isOn = ConfigManager.getInstance.isDarkMode
        currencySegmented.selectedSegmentIndex = ConfigManager.getInstance.currencyType
        periodSegmented.selectedSegmentIndex = ConfigManager.getInstance.periodType
        var version: String? {
            guard let dictionary = Bundle.main.infoDictionary,
                  let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
            let versionBuild: String = version
            return versionBuild
        }
        versionLabel.text = "Version \(version!)" 
    }
    func addTarget() {
        darkModeSwitch.addTarget(self, action: #selector(handleDarkmodeSwitch(sender:)), for: .touchUpInside)
        currencySegmented.addTarget(self, action: #selector(handleCurrencySeg(sender:)), for: .valueChanged)
        periodSegmented.addTarget(self, action: #selector(handlePeriodSeg(sender:)), for: .valueChanged)
    }
    @objc func handleDarkmodeSwitch(sender: UISwitch) {
        if sender.isOn {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
            ConfigManager.getInstance.isDarkMode = true
            UserDefaults.standard.set(true, forKey: Constants.IS_DARK_MODE)
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
            ConfigManager.getInstance.isDarkMode = false
            UserDefaults.standard.set(false, forKey: Constants.IS_DARK_MODE)
        }
    }
    @objc func handleCurrencySeg(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
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
    @objc func handlePeriodSeg(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
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
    @IBAction func tapPrivacyPolicyButton(_ sender: UIButton) {
        guard let privacyURL = URL(string: "https://app-privacy-policy.netlify.app/") else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safari = SFSafariViewController(url: privacyURL, configuration: config)
        safari.preferredBarTintColor = UIColor.white
        safari.preferredControlTintColor = UIColor.systemBlue
        
        present(safari, animated: true, completion: nil)
    }
}
