//
//  EmailViewController.swift
//  Flicker
//
//  Created by Taehwan Kim on 2022/11/21.
//

import UIKit
import MessageUI

enum ReportType {
    case askSomething
    case reportAnotherUser
    case reportChatUser
}

class EmailViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - MFMailComposeViewControllerDelegate. 해당 델리게이트를 이용하여 email 송신 기능 가능
extension EmailViewController: MFMailComposeViewControllerDelegate {
    
    func sendReportMail(userName: String?, reportType: ReportType) {
        if MFMailComposeViewController.canSendMail() {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let currentDateString = formatter.string(from: Date())
            let composeViewController = MFMailComposeViewController()
            let dimeEmail = "haptic_04_minis@icloud.com"
            switch reportType {
            case .askSomething:
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
            case .reportAnotherUser:
                let messageBody = """
                                  -----------------------------
                                  - 신고자: \(String(describing: userName ?? "UNKNOWN"))
                                  - 일시: \(currentDateString)
                                  ------------------------------
                                  - 신고 사유 (상대의 이름, 왜 신고하시는지)
                                  
                                  
                                  
                                  
                                  """
                composeViewController.mailComposeDelegate = self
                composeViewController.setToRecipients([dimeEmail])
                composeViewController.setSubject("")
                composeViewController.setMessageBody(messageBody, isHTML: false)
                self.present(composeViewController, animated: true, completion: nil)
            case .reportChatUser:
                let messageBody = """
                                  -----------------------------
                                  - 신고자: \(String(describing: userName ?? "UNKNOWN"))
                                  - 신고일시: \(currentDateString)
                                  ------------------------------
                                  - 신고사유
                                  
                                  
                                  
                                  
                                  """
                composeViewController.mailComposeDelegate = self
                composeViewController.setToRecipients([dimeEmail])
                composeViewController.setSubject("")
                composeViewController.setMessageBody(messageBody, isHTML: false)
                self.present(composeViewController, animated: true, completion: nil)
            }
        }
        else {
            showSendMailErrorAlert()
        }
    }

    func showSendMailErrorAlert() {
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
