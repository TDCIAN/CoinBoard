//
//  ChartListViewController.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/03.
//

import UIKit

class ChartListViewController: UIViewController {
    
    @IBOutlet weak var chartCollectionView: UICollectionView!
    @IBOutlet weak var chartTableView: UITableView!
    @IBOutlet weak var chartTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ChartListViewController {
    private func adjustTableViewHeight() {
        chartTableViewHeight.constant = chartTableView.contentSize.height
    }
    
    private func showDetail() {
        let storyboard = UIStoryboard(name: "Chart", bundle: .main)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ChartDetailViewController") as? ChartDetailViewController {
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}

extension ChartListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartCardCell", for: indexPath) as? ChartCardCell else { return UICollectionViewCell() }
        return cell
    }
    
}

class ChartCardCell: UICollectionViewCell {
    
}

extension ChartListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartListCell", for: indexPath) as? ChartListCell else { return UITableViewCell() }
        cell.backgroundColor = .systemTeal
        return cell
    }
}

class ChartListCell: UITableViewCell {
    
}
