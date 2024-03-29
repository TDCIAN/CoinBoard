//
//  ChartListViewController.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/03.
//

import UIKit
import Charts

typealias CoinInfo = (key: CoinType, value: Coin)

class ChartListViewController: UIViewController {
    
    @IBOutlet weak var chartCollectionView: UICollectionView!
    @IBOutlet weak var chartTableView: UITableView!
    @IBOutlet weak var chartTableViewHeight: NSLayoutConstraint!
    
    var viewModel: ChartListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ChartListViewModel(changeHandler: { coinInfos in
            DispatchQueue.main.async {
                self.chartCollectionView.reloadData()
                self.chartTableView.reloadData()
                self.adjustTableViewHeight()
            }
        })
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chartCollectionView.reloadData()
        chartTableView.reloadData()
    }
}

extension ChartListViewController {
    private func adjustTableViewHeight() {
        chartTableViewHeight.constant = chartTableView.contentSize.height
    }
    
    private func showDetail(coinInfo: CoinInfo) {
        let storyboard = UIStoryboard(name: "Chart", bundle: .main)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ChartDetailViewController") as? ChartDetailViewController {
            detailVC.viewModel = ChartDetailViewModel(coinInfo: coinInfo, chartDatas: [], selectedPeriod: .day, changeHandler: { _, _ in })
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension ChartListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCoinInfoList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartCardCell", for: indexPath) as? ChartCardCell else { return UICollectionViewCell() }
        let coinInfo = viewModel.coinInfo(at: indexPath)
        let customPeriod = UserDefaults.standard.integer(forKey: Constants.PERIOD_TYPE)
        cell.viewModel = ChartCardCellViewModel(coinInfo: coinInfo, chartDatas: [], periodType: customPeriod, changeHandler: { _, _ in })
        cell.viewModel.updateNotify { chartDatas, selectedPeriod in
            cell.renderChart(with: chartDatas, period: selectedPeriod)
        }
        cell.viewModel.fetchData()
        cell.updateCoinInfo(cell.viewModel)
        return cell
    }
}

extension ChartListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - 15 * 2
        let height: CGFloat = 300
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetail(coinInfo: viewModel.coinInfo(at: indexPath))
    }
}

extension ChartListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartCardCell", for: $0) as? ChartCardCell
            let coinInfo = viewModel.coinInfo(at: $0)
            let customPeriod = UserDefaults.standard.integer(forKey: Constants.PERIOD_TYPE)
            cell?.viewModel = ChartCardCellViewModel(coinInfo: coinInfo, chartDatas: [], periodType: customPeriod, changeHandler: { _, _ in })
            cell?.viewModel.updateNotify { chartDatas, selectedPeriod in
                cell?.renderChart(with: chartDatas, period: selectedPeriod)
            }
            cell?.viewModel.fetchData()
            cell?.updateCoinInfo(cell?.viewModel ?? ChartCardCellViewModel(coinInfo: coinInfo, chartDatas: [], periodType: customPeriod, changeHandler: { _, _ in }))
        }
    }
}

extension ChartListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCoinInfoList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.cell(for: indexPath, at: tableView)
        return cell
    }
}

extension ChartListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(coinInfo: viewModel.coinInfo(at: indexPath))
    }
}

