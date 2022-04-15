//
//  OpenSourceViewController.swift
//  CoinBoard
//
//  Created by APPLE on 2021/02/08.
//

import SnapKit
import UIKit

struct OpenSourceLicenseData {
    var name: String?
    var address: String?
    var license: String?
}

class OpenSourceViewController: UIViewController {
    
    @IBOutlet weak var openSourceTitleLabel: UILabel!
    
    lazy var openSourceTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OpenSourceLicenseTableViewCell.self, forCellReuseIdentifier: OpenSourceLicenseTableViewCell.reusableIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tertiarySystemBackground
        return tableView
    }()
    var openSourceLicenseDataArray: [OpenSourceLicenseData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.openSourceTableView.reloadData()
            }
        }
    }
    var ARR_OPEN_SOURCE_NAME = [
        "Alamofire",
        "Kingfisher",
        "Charts",
        "SwiftyJSON",
        "SnapKit",
        "Then"
    ]
    var ARR_OPEN_SOURCE_ADDRESS = [
        "https://github.com/Alamofire/Alamofire",
        "https://github.com/onevcat/Kingfisher",
        "https://github.com/danielgindi/Charts",
        "https://github.com/SnapKit/SnapKit"
    ]
    var ARR_LICENSE_TEXT = [
        "MIT license",
        "MIT license",
        "Apache License",
        "MIT license"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemBackground
        setupView()
        addLicenseData()
    }
    
    func setupView() {
        view.addSubview(openSourceTableView)
        openSourceTableView.snp.makeConstraints {
            $0.top.equalTo(openSourceTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
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

extension OpenSourceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

class OpenSourceLicenseTableViewCell: UITableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()
    let licenseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .tertiarySystemBackground
        self.selectionStyle = .none
        setupView()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(urlLabel)
        contentView.addSubview(licenseLabel)
    }
    
    func makeConstraints() {
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.top.equalTo(15)
        }
        urlLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(20)
        }
        licenseLabel.snp.makeConstraints {
            $0.top.equalTo(urlLabel.snp.bottom).offset(5)
            $0.leading.equalTo(20)
        }
    }
    
    
    func configCell(openSourceInfo: OpenSourceLicenseData) {
        nameLabel.text = openSourceInfo.name
        urlLabel.text = openSourceInfo.address
        licenseLabel.text = openSourceInfo.license
    }
    
}

extension NSObject {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
