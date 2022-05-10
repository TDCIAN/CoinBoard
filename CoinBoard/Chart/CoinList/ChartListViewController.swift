//
//  ChartListViewController.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/03.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

typealias CoinInfo = (key: CoinType, value: Coin)

class ChartListViewController: UIViewController {
    
    @IBOutlet weak var chartCollectionView: UICollectionView!
    @IBOutlet weak var coinListTableView: UITableView!
    @IBOutlet weak var coinListTableViewHeight: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    let chartViewModel = ChartViewModel()
    let coinViewModel = CoinViewModel()
    
    var customPeriod: Period {
        let customPeriod = UserDefaults.standard.integer(forKey: Constants.PERIOD_TYPE)
        switch customPeriod {
        case 0:
            return .day
        case 1:
            return .week
        case 2:
            return .month
        case 3:
            return .year
        default:
            return .day
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindCoinList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chartCollectionView.reloadData()
        coinListTableView.reloadData()
    }
    
    func bindCoinList() {
        coinViewModel.loadCoinList()
        
        coinViewModel.coinListCellData
            .asDriver(onErrorJustReturn: [])
            .drive(
                coinListTableView.rx.items(
                    cellIdentifier: CoinListCell.identifier,
                    cellType: CoinListCell.self
                )
            ) { _, data, cell in
                cell.configCell(coinModel: data)
                self.adjustTableViewHeight()
                self.chartCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        Observable.zip(
            coinListTableView.rx.modelSelected(CoinModel.self),
            coinListTableView.rx.itemSelected
        )
        .bind { [weak self] coinModel, indexPath in
            guard let self = self else { return }
            self.coinListTableView.deselectRow(at: indexPath, animated: true)
            self.showDetail(coinInfo: coinModel)
        }
        .disposed(by: disposeBag)
    }
}

extension ChartListViewController {
    private func adjustTableViewHeight() {
        coinListTableViewHeight.constant = coinListTableView.contentSize.height
    }

    private func showDetail(coinInfo: CoinModel) {
        let storyboard = UIStoryboard(name: "Chart", bundle: .main)
        if let detailVC = storyboard.instantiateViewController(
            withIdentifier: "ChartDetailViewController"
        ) as? ChartDetailViewController {
            detailVC.viewModel = ChartDetailViewModel(
                coinInfo: coinInfo,
                chartDatas: [],
                selectedPeriod: .day,
                changeHandler: { _, _ in }
            )
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension ChartListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinViewModel.coinListCellData.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChartCardCell.identifier,
            for: indexPath
        ) as? ChartCardCell else {
            return UICollectionViewCell()
        }
        let coinInfo = coinViewModel.coinListCellData.value[indexPath.row]
        let customPeriod = UserDefaults.standard.integer(forKey: Constants.PERIOD_TYPE)
        print("셀: \(indexPath.row), 코인 이름: \(coinInfo.key.rawValue)")
        cell.viewModel = ChartCardCellViewModel(
            coinInfo: coinInfo,
            chartDatas: [],
            periodType: customPeriod,
            changeHandler: { _, _ in }
        )
        
//        cell.viewModel.updateNotify { chartDatas, selectedPeriod in
//            cell.renderChart(with: chartDatas, period: selectedPeriod)
//        }
//        cell.viewModel.loadChartData(coinType: <#CoinType#>, period: <#Period#>)
        /* 실제 순서상으로는
         1. 뷰모델이 coinInfo, customPeriod를 가지고 loadChartData
         2. loadChartData가 완료되면 나온 결과물로 renderChart
         */
        return cell
    }
}

extension ChartListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = collectionView.frame.width - 15 * 2
        let height: CGFloat = 300
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetail(coinInfo: coinViewModel.coinListCellData.value[indexPath.row])
    }
}

extension ChartListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ChartCardCell.identifier,
                for: $0
            ) as? ChartCardCell
            let coinInfo = coinViewModel.coinListCellData.value[$0.row]
            let customPeriod = UserDefaults.standard.integer(forKey: Constants.PERIOD_TYPE)
            print("프리패칭 - 셀: \($0), 코인 이름: \(coinInfo.key.rawValue)")
            cell?.viewModel = ChartCardCellViewModel(
                coinInfo: coinInfo,
                chartDatas: [],
                periodType: customPeriod,
                changeHandler: { _, _ in }
            )
//            cell?.viewModel.updateNotify { chartDatas, selectedPeriod in
//                cell?.renderChart(with: chartDatas, period: selectedPeriod)
//            }
//            cell?.viewModel.loadChartData()
        }
    }
}
