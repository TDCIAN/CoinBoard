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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel)
    }

    func bind(_ viewModel: SettingsViewModel) {
        viewModel.isDarkModeOn
            .bind(to: darkModeSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        darkModeSwitch.rx.value.bind { isOn in
            viewModel.handleDarkmodeSwitch(isOn: isOn)
        }.disposed(by: disposeBag)
        
        viewModel.selectedCurrencyIndex
            .bind(to: currencySegmented.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
        
        currencySegmented.rx.value.bind { index in
            viewModel.handleCurrencySeg(selectedIndex: index)
        }.disposed(by: disposeBag)
        
        viewModel.selectedPeriodIndex
            .bind(to: periodSegmented.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
        
        periodSegmented.rx.value.bind { index in
            viewModel.handlePeriodSeg(selectedIndex: index)
        }.disposed(by: disposeBag)
        
        viewModel.currentVersion
            .bind(to: versionLabel.rx.text)
            .disposed(by: disposeBag)
        
        privacyPolicyButton.rx.tap.bind {
            viewModel.tapPrivacyPolicyButton { safari in
                self.present(safari, animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
    }
}
