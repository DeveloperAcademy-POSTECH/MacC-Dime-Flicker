//
//  ProfileViewController.swift
//  Flicker
//
//  Created by Taehwan Kim on 2022/11/02.
//
import MessageUI
import UIKit

final class ProfileViewController: BaseViewController {
    // MARK: - Properties
    private let userName: String? = nil
    private var isArtist: Bool = false
    private let sectionHeaderTitle = ["설정"]
    private let NotArtistCells = ["알림", "작가등록", "문의하기"]
    private let ArtistCells = ["알림", "작가설정", "문의하기"]
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
//        tabBarController?.tabBar.isHidden = true
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
    private func goToCustomerInquiry() {
        self.sendReportMail()
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.className, for: indexPath) as! ProfileTableViewCell
        //cell.accessoryType = .disclosureIndicator
        if isArtist {
            cell.cellTextLabel.text = ArtistCells[indexPath.row]
        } else {
            cell.cellTextLabel.text = NotArtistCells[indexPath.row]
        }
        switch indexPath.row {
        case 0:
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(true, animated: true)
            switchView.addTarget(self, action: #selector(changedSwitch), for: .valueChanged)
            cell.accessoryView = switchView
            cell.selectionStyle = .none
        default:
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArtistCells.count
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
            goToArtistRegistration()
        case 2:
            goToCustomerInquiry()
        default:
            print("")
        }
    }
}
 
// MARK: - MFMailComposeViewControllerDelegate
extension ProfileViewController: MFMailComposeViewControllerDelegate {
    func sendReportMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            let dimeEmail = "haptic_04_minis@icloud.com"
            let messageBody = """
                              -----------------------------
                              - 문의하시는 분: \(String(describing: userName ?? "UNKNOWN"))
                              - 문의 날짜: \(Date())
                              ------------------------------
                              내용:

                              
                              """

            composeViewController.mailComposeDelegate = self
            composeViewController.setToRecipients([dimeEmail])
            composeViewController.setSubject("[문의 사항]")
            composeViewController.setMessageBody(messageBody, isHTML: false)

            self.present(composeViewController, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }

    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
