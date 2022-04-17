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
    let viewModel = CoinViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chartCollectionView.reloadData()
        coinListTableView.reloadData()
    }
    
    func bind() {
        viewModel.loadCoinList()
        
        viewModel.coinListCellData
            .asDriver(onErrorJustReturn: [])
            .drive(
                coinListTableView.rx.items(
                    cellIdentifier: ChartListCell.identifier,
                    cellType: ChartListCell.self
                )
            ) { _, data, cell in
                cell.configCell(coinModel: data)
                self.adjustTableViewHeight()
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
    
//    private func showDetail(coinInfo: CoinInfo) {
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
//        return viewModel.numberOfCoinInfoList
        return viewModel.coinListCellData.value.count
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
//        let coinInfo = viewModel.coinInfo(at: indexPath)
        let coinInfo = viewModel.coinListCellData.value[indexPath.row]
        let customPeriod = UserDefaults.standard.integer(forKey: Constants.PERIOD_TYPE)
        cell.viewModel = ChartCardCellViewModel(
            coinInfo: coinInfo,
            chartDatas: [],
            periodType: customPeriod,
            changeHandler: { _, _ in }
        )
        cell.viewModel.updateNotify { chartDatas, selectedPeriod in
            cell.renderChart(with: chartDatas, period: selectedPeriod)
        }
        cell.viewModel.fetchData()
        cell.updateCoinInfo(cell.viewModel)
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
//        showDetail(coinInfo: viewModel.coinInfo(at: indexPath))
        showDetail(coinInfo: viewModel.coinListCellData.value[indexPath.row])
    }
}

extension ChartListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ChartCardCell.identifier,
                for: $0
            ) as? ChartCardCell
//            let coinInfo = viewModel.coinInfo(at: $0)
            let coinInfo = viewModel.coinListCellData.value[$0.row]
            let customPeriod = UserDefaults.standard.integer(forKey: Constants.PERIOD_TYPE)
            cell?.viewModel = ChartCardCellViewModel(
                coinInfo: coinInfo,
                chartDatas: [],
                periodType: customPeriod,
                changeHandler: { _, _ in }
            )
            cell?.viewModel.updateNotify { chartDatas, selectedPeriod in
                cell?.renderChart(with: chartDatas, period: selectedPeriod)
            }
            cell?.viewModel.fetchData()
            cell?.updateCoinInfo(cell?.viewModel ?? ChartCardCellViewModel(
                coinInfo: coinInfo,
                chartDatas: [],
                periodType: customPeriod,
                changeHandler: { _, _ in })
            )
        }
    }
}
