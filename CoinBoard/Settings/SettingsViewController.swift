//
//  SettingViewController.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/03.
//

import UIKit
import RxSwift

final class SettingsViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    let viewModel = SettingsViewModel()
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var currencySegmented: UISegmentedControl!
    @IBOutlet weak var periodSegmented: UISegmentedControl!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    private var version: String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        let versionBuild: String = version
        return versionBuild
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind(viewModel)
    }
    func setup() {
        darkModeSwitch.isOn = ConfigManager.getInstance.isDarkMode
        currencySegmented.selectedSegmentIndex = ConfigManager.getInstance.currencyType
        periodSegmented.selectedSegmentIndex = ConfigManager.getInstance.periodType
        versionLabel.text = "Version \(version)"
    }
    
    func bind(_ viewModel: SettingsViewModel) {
        darkModeSwitch.rx.value.bind { isOn in
            viewModel.handleDarkmodeSwitch(isOn: isOn)
        }.disposed(by: disposeBag)
        
        currencySegmented.rx.value.bind { index in
            viewModel.handleCurrencySeg(selectedIndex: index)
        }.disposed(by: disposeBag)
        
        periodSegmented.rx.value.bind { index in
            viewModel.handlePeriodSeg(selectedIndex: index)
        }.disposed(by: disposeBag)
        
        privacyPolicyButton.rx.tap.bind {
            viewModel.tapPrivacyPolicyButton { safari in
                self.present(safari, animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
    }
}
