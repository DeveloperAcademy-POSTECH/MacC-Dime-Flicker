//
//  ProfileViewController.swift
//  Flicker
//
//  Created by Taehwan Kim on 2022/11/02.
//

import UIKit

final class ProfileViewController: BaseViewController {
    // MARK: - Properties
    private let sectionHeaderTitle = ["설정"]
    private let userProfileCell = UIView(frame: .zero)
    private let profileHeader = ProfileHeaderVIew()
    private let tableView = UITableView(frame: CGRectZero, style: .insetGrouped).then {
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
        view.addSubviews(tableView, profileHeader)
        tableView.tableHeaderView = profileHeader
    }

    override func render() {
        view.backgroundColor = .systemGray6
        view.addSubviews(tableView, profileHeader)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        profileHeader.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(tableView.snp.top)
            $0.height.equalTo(180)
        }
        tableView.tableHeaderView = profileHeader
    }

    private func setFunctionsAndDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    // MARK: - Setting Functions
    @objc func changedSwitch(_ sender: UISwitch) {
        print(sender.isOn)
        if !sender.isOn {
            // 알림을 중지한다는 팝업. 필요한지 의문
            let notificationAlert = UIAlertController(title: "알림 비활성화", message: "", preferredStyle: .alert)
            notificationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            }))
            self.present(notificationAlert, animated: true)
        } else {
            //let notificationCenter = UNUserNotificationCenter.current()
        }
    }
    private func goToArtistRegistration() {
        navigationController?
            .pushViewController(RegisterWelcomeViewController(), animated: true)
    }
//    private func goToCustomerInquiry() {
//
//    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.className, for: indexPath) as! ProfileTableViewCell
        cell.accessoryType = .disclosureIndicator
        switch ProfileSection(rawValue: indexPath.section) {
        case .myActivity:
            cell.setupCellData(ProfileSection.myActivity.sectionOption[indexPath.row], spacing: 5)
            if indexPath.row != 0 {
                cell.accessoryType = .disclosureIndicator
            } else {
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(true, animated: true)
                switchView.addTarget(self, action: #selector(changedSwitch), for: .valueChanged)
                cell.accessoryView = switchView
                cell.selectionStyle = .none
            }
//        case .service:
//            cell.setupCellData(ProfileSection.service.sectionOption[indexPath.row], spacing: 5)
        case .none:
            print("default")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ProfileSection(rawValue: section) {
        case .myActivity: return MyActivities.allCases.count
        case .none:
            return 0
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionHeaderTitle[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            print("작가등록")
//            goToArtistRegistration()
            self.navigationController?.pushViewController(AccountDeleteViewController(), animated: true)
        case 2:
            print("문의하기")
        default:
            print("의도하지 않은 호출")
        }
    }
}
 
//// MARK: - MFMailComposeViewControllerDelegate
//extension ProfileViewController: MFMailComposeViewControllerDelegate {
//    func sendReportMail() {
//        if MFMailComposeViewController.canSendMail() {
//            let composeVC = MFMailComposeViewController()
//            let aenittoEmail = "aenitto@gmail.com"
//            let messageBody = """
//
//                              -----------------------------
//
//                              - 문의하는 닉네임: \(String(describing: UserDefaultStorage.nickname ?? ""))
//                              - 문의 메시지 제목 한줄 요약:
//                              - 문의 날짜: \(Date())
//
//                              ------------------------------
//
//                              문의 내용을 작성해주세요.
//
//                              """
//
//            composeVC.mailComposeDelegate = self
//            composeVC.setToRecipients([aenittoEmail])
//            composeVC.setSubject("[문의 사항]")
//            composeVC.setMessageBody(messageBody, isHTML: false)
//
//            self.present(composeVC, animated: true, completion: nil)
//        }
//        else {
//            self.showSendMailErrorAlert()
//        }
//    }
//
//    private func showSendMailErrorAlert() {
//        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
//        let confirmAction = UIAlertAction(title: "확인", style: .default) {
//            (action) in
//            print("확인")
//        }
//        sendMailErrorAlert.addAction(confirmAction)
//        self.present(sendMailErrorAlert, animated: true, completion: nil)
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}
