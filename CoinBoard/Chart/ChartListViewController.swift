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
}

extension ChartListViewController {
    private func adjustTableViewHeight() {
        chartTableViewHeight.constant = chartTableView.contentSize.height
    }
    
    private func showDetail(coinInfo: CoinInfo) {
        let storyboard = UIStoryboard(name: "Chart", bundle: .main)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ChartDetailViewController") as? ChartDetailViewController {
//            detailVC.viewModel
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
//        cell.viewModel
        return cell
    }
    
}

class ChartCardCell: UICollectionViewCell {
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var lastChangeLabel: UILabel!
    @IBOutlet weak var chartViewForCardCell: LineChartView!
    
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

