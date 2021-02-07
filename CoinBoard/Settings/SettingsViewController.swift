//
//  SettingViewController.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/03.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var currencySegmented: UISegmentedControl!
    @IBOutlet weak var periodSegmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addTarget()
    }
    
    func setupView() {
        darkModeSwitch.isOn = ConfigManager.getInstance.isDarkMode
        currencySegmented.selectedSegmentIndex = ConfigManager.getInstance.currencyType
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
            print("USD 눌렀네: \(sender.selectedSegmentIndex)")
            ConfigManager.getInstance.currencyType = 0
            UserDefaults.standard.set(0, forKey: Constants.CURRENCY_TYPE)
        case 1:
            print("KRW 눌렀네: \(sender.selectedSegmentIndex)")
            ConfigManager.getInstance.currencyType = 1
            UserDefaults.standard.set(1, forKey: Constants.CURRENCY_TYPE)
        default:
            ConfigManager.getInstance.currencyType = 0
            UserDefaults.standard.set(0, forKey: Constants.CURRENCY_TYPE)
            print("기본은 USD임: \(sender.selectedSegmentIndex)")
        }
    }
    
    @objc func handlePeriodSeg(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Day 눌렀네: \(sender.selectedSegmentIndex)")
            UserDefaults.standard.set(0, forKey: Constants.PERIOD_TYPE)
        case 1:
            print("Week 눌렀네: \(sender.selectedSegmentIndex)")
            UserDefaults.standard.set(1, forKey: Constants.PERIOD_TYPE)
        case 2:
            print("Month 눌렀네: \(sender.selectedSegmentIndex)")
            UserDefaults.standard.set(2, forKey: Constants.PERIOD_TYPE)
        case 3:
            print("Year 눌렀네: \(sender.selectedSegmentIndex)")
            UserDefaults.standard.set(3, forKey: Constants.PERIOD_TYPE)
        default:
            print("기본은 Day임: \(sender.selectedSegmentIndex)")
            UserDefaults.standard.set(0, forKey: Constants.PERIOD_TYPE)
        }
    }
}
