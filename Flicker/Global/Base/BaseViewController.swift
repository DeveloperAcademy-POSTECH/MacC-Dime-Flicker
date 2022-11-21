//
//  BaseViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import Then
import AuthenticationServices
import Firebase
import FirebaseAuth
import FirebaseFirestore
import MessageUI

class BaseViewController: UIViewController {
    // MARK: - property
    private lazy var backButton = BackButton().then {
        $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    private var activeTextField : UITextField? = nil
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        setupBackButton()
        hidekeyboardWhenTappedAround()
        setupNavigationBar()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func render() {
        // Override Layout
    }
    
    func configUI() {
        view.backgroundColor = .white
    }
    
    func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let largeFont = UIFont.systemFont(ofSize: 34, weight: .semibold)
        
        appearance.titleTextAttributes = [.font: font]
        appearance.largeTitleTextAttributes = [.font: largeFont]
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - helper func
    
    func makeBarButtonItem<T: UIView>(with view: T) -> UIBarButtonItem {
        return UIBarButtonItem(customView: view)
    }
    
    func removeBarButtonItemOffset(with button: UIButton, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let offsetView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        offsetView.bounds = offsetView.bounds.offsetBy(dx: offsetX, dy: offsetY)
        offsetView.addSubview(button)
        return offsetView
    }

    func setupBackButton() {
        let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 10)
        let backButton = makeBarButtonItem(with: leftOffsetBackButton)
        
        navigationItem.leftBarButtonItem = backButton
    }

    // MARK: - private func
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupInteractivePopGestureRecognizer() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        var shouldMoveViewUp = false
        
        // if active text field is not nil
        if let activeTextField = activeTextField {
            
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        // go through all of the textfield inside the view, and end editing thus resigning first responder
        // ie. it will trigger a keyboardWillHide notification
        self.view.endEditing(true)
    }
    
}

extension BaseViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let count = self.navigationController?.viewControllers.count else { return false }
        return count > 1
    }
}

extension BaseViewController {
    
    func goLogin() {
        let viewController = LogInViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }

    //이메일 유효성 검사
    func emailValidCheck(_ textField: UITextField) -> Bool {
        //맨 처음은 영어, 대문자, 소문자, 툭수문자 모두 가능하다는 뜻이며, +@는 사이에 @가 무조건 있어야 하며
        //@ 뒤에는 대문자,소문자,숫자,.,-만 되고 . 이 온 이후는 영어대문자,소문자만 가능하며
        //마지막은 2~64글자까지만 허용한다는 emailValid입니다.
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        //bool값임
        return  emailTest.evaluate(with: textField.text)
    }
    //비밀번호의 길이가 6자리 이상일 경우에만 true값 전달
    func passwordValidCheck(_ textField: UITextField) -> Bool {
        guard let passwordCount = textField.text?.count else { return false }

        if passwordCount >= 6 {
            return true
        } else { return false }
    }

    func passwordSameCheck(_ textField: UITextField, _ checkTextField: UITextField) -> Bool {
        if textField.text == checkTextField.text {
            return true
        } else { return false }
    }
}

// MARK: - MFMailComposeViewControllerDelegate. 해당 델리게이트를 이용하여 email 송신 기능 가능
extension BaseViewController: MFMailComposeViewControllerDelegate {
    enum ReportType {
        case askSomething
        case reportAnotherUser
        case reportChatUser
    }
    
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
