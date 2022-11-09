//
//  ProfileViewController.swift
//  Flicker
//
//  Created by Taehwan Kim on 2022/11/02.
//

import UIKit

final class ProfileViewController: BaseViewController {

    private let sectionHeaderTitle = ["설정", "기타"]
    private let userProfileCell = UIView(frame: .zero)
    private let profileHeader = ProfileHeaderVIew()
    private let profileTableView = UITableView(frame: CGRectZero, style: .insetGrouped).then {
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.className)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        setFunctionsAndDelegate()
        customSetUI()
    }
    private func customSetUI() {
        view.addSubviews(profileTableView, profileHeader)
        profileTableView.tableHeaderView = profileHeader
    }

    override func render() {
        view.backgroundColor = .systemGray6
        view.addSubviews(profileTableView, profileHeader)
        profileTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        profileHeader.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(profileTableView.snp.top)
            $0.height.equalTo(180)
        }
        profileTableView.tableHeaderView = profileHeader
    }

    private func setFunctionsAndDelegate() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.className, for: indexPath) as! ProfileTableViewCell
        cell.accessoryType = .disclosureIndicator
        
        switch ProfileSection(rawValue: indexPath.section) {
        case .myActivity:
            cell.setupCellData(ProfileSection.myActivity.sectionOption[indexPath.row], spacing: 5)
        case .service:
            cell.setupCellData(ProfileSection.service.sectionOption[indexPath.row], spacing: 5)
        case .none:
            print("default")
        }
        
        return cell
    }
    

}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ProfileSection(rawValue: section) {
        case .myActivity: return MyActivities.allCases.count
        case .service: return ServiceOption.allCases.count
        case .none:
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitle.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionHeaderTitle[section]
    }
}
