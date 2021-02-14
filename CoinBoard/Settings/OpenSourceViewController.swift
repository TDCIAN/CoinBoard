//
//  OpenSourceViewController.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/08.
//

import UIKit

struct OpenSourceLicenseData {
    var name: String?
    var address: String?
    var license: String?
}

class OpenSourceViewController: UIViewController {
    
    var openSourceLicenseDataArray = [OpenSourceLicenseData]()
    var ARR_OPEN_SOURCE_NAME = [
        "Alamofire",
        "Kingfisher",
        "Charts",
        "SwiftyJSON"
    ]
    var ARR_OPEN_SOURCE_ADDRESS = [
        "https://github.com/Alamofire/Alamofire",
        "https://github.com/onevcat/Kingfisher",
        "https://github.com/danielgindi/Charts",
        "https://github.com/SwiftyJSON/SwiftyJSON"
    ]
    var ARR_LICENSE_TEXT = [
        "MIT license",
        "MIT license",
        "Apache License",
        "MIT license"
    ]

    @IBOutlet weak var opensourceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLicenseData()
    }

    func addLicenseData() {
        for i in 0..<ARR_OPEN_SOURCE_NAME.count {
            openSourceLicenseDataArray.append(OpenSourceLicenseData(name: ARR_OPEN_SOURCE_NAME[i], address: ARR_OPEN_SOURCE_ADDRESS[i], license: ARR_LICENSE_TEXT[i]))
        }
    }
}

extension OpenSourceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openSourceLicenseDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpenSourceLicenseTableViewCell", for: indexPath) as? OpenSourceLicenseTableViewCell else { return UITableViewCell() }
        let openSourceInfo = openSourceLicenseDataArray[indexPath.row]
        cell.configCell(openSourceInfo: openSourceInfo)
        return cell
    }
    
    
}

class OpenSourceLicenseTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    
    
    func configCell(openSourceInfo: OpenSourceLicenseData) {
        nameLabel.text = openSourceInfo.name
        urlLabel.text = openSourceInfo.address
        licenseLabel.text = openSourceInfo.license
    }
    
}
