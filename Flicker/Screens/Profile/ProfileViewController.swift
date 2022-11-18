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
        setFunctionsAndDelegate()
        render()
        setTabGesture()
    }
    // MARK: - rendering Functions
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func render() {
        view.backgroundColor = .systemGray6
        view.addSubviews(tableView, profileHeader)

        profileHeader.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(tableView.snp.top)
            $0.height.equalTo(180)
        }

        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.tableHeaderView = profileHeader
    }

    private func setFunctionsAndDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func setTabGesture() {
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGesture))
        self.profileHeader.addGestureRecognizer(tabGesture)
    }
    // MARK: - Setting Functions
    @objc func didTapGesture() {
        let viewController = InputPasswordViewController()
        let modalNavigationController = UINavigationController(rootViewController: viewController)
        present(modalNavigationController, animated: true)
    }
    @objc func didToggleSwitch(_ sender: UISwitch) {
        print(sender.isOn)
        if !sender.isOn {
            makeAlert(title: "알림 비활성화", message: "")
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

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.className, for: indexPath) as! ProfileTableViewCell
        if isArtist {
            cell.cellTextLabel.text = ArtistCells[indexPath.row]
        } else {
            cell.cellTextLabel.text = NotArtistCells[indexPath.row]
        }
        switch indexPath.row {
        case 0:
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(true, animated: true)
            switchView.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
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

// MARK: - UITableViewDelegate
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
 
// MARK: - MFMailComposeViewControllerDelegate. 해당 델리게이트를 이용하여 email 송신 기능 가능
extension ProfileViewController: MFMailComposeViewControllerDelegate {
    func sendReportMail() {
        if MFMailComposeViewController.canSendMail() {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let currentDateString = formatter.string(from: Date())
            let composeViewController = MFMailComposeViewController()
            let dimeEmail = "haptic_04_minis@icloud.com"
            let messageBody = """
                              -----------------------------
                              - 문의하시는 분: \(String(describing: userName ?? "UNKNOWN"))
                              - 문의 날짜: \(currentDateString)
                              ------------------------------
                              - 내용

                              
                              
                              
                              """

            composeViewController.mailComposeDelegate = self
            composeViewController.setToRecipients([dimeEmail])
            composeViewController.setSubject("")
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
