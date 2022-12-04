//
//  PopUpViewController.swift
//  Flicker
//
//  Created by 김연호 on 2022/11/17.
//

import UIKit

import SnapKit
import Then
import FirebaseAuth

final class PopUpViewController: BaseViewController  {

    private let popUpView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = DeviceFrame.screenHeight * 0.018
    }

    private let mainLabel = UILabel().makeBasicLabel(labelText: "이메일을 입력하세요", textColor: .mainPink, fontStyle: .title2, fontWeight: .bold)

    private let subLabel = UILabel().makeBasicLabel(labelText: "이메일로 비밀번호 재설정을 해요!", textColor: .textMainBlack, fontStyle: .callout, fontWeight: .bold)

    private let emailField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        $0.autocorrectionType = .no
        $0.backgroundColor = .loginGray
        $0.attributedPlaceholder = NSAttributedString(string: "이메일 주소", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.cornerRadius = DeviceFrame.screenHeight * 0.014
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
    }

    private let emailValidCheckLabel = UILabel().makeBasicLabel(labelText: "이메일 주소를 확인해 주세요.", textColor: .red, fontStyle: .subheadline, fontWeight: .light)

    private let sendEmailButton = UIButton().then {
        $0.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        $0.backgroundColor = .systemGray
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("보내기", for: .normal)
        $0.layer.cornerRadius = DeviceFrame.screenHeight * 0.018
    }

    private let cancleButton = UIButton().then {
        $0.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        $0.backgroundColor = .systemGray2
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("나가기", for: .normal)
        $0.layer.cornerRadius = DeviceFrame.screenHeight * 0.018
    }


    override func render() {

        view.addSubview(popUpView)

        emailField.delegate = self

        popUpView.addSubviews(mainLabel, subLabel, emailField, emailValidCheckLabel ,sendEmailButton, cancleButton)

        cancleButton.addTarget(self, action: #selector(didTapCancleButton), for: .touchUpInside)
        sendEmailButton.addTarget(self, action: #selector(didTapSendEmailButton), for: .touchUpInside)

        popUpView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(DeviceFrame.screenHeight * 0.27)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(DeviceFrame.screenWidth * 0.85)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.37)
        }

        mainLabel.snp.makeConstraints {
            $0.top.equalTo(popUpView.snp.top).offset(DeviceFrame.screenHeight * 0.053)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.047)
        }

        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.035)
        }

        emailField.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.065)
        }

        emailValidCheckLabel.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(40)
        }
        
        sendEmailButton.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(DeviceFrame.screenHeight * 0.042)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.05)
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalTo(emailField.snp.centerX).offset(-5)
        }

        cancleButton.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(DeviceFrame.screenHeight * 0.042)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.05)
            $0.leading.equalTo(emailField.snp.centerX).offset(5)
            $0.trailing.equalToSuperview().inset(30)

        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        emailValidCheckLabel.isHidden = true
        sendEmailButton.isEnabled = false
    }

    @objc func didTapSendEmailButton() {

        if emailValidCheck(emailField) {
            Auth.auth().sendPasswordReset(withEmail: emailField.text ?? "" ) { error in
                if error != nil {
                    self.makeAlert(title: "이메일보내기에 실패했습니다.", message: "이메일을 확인 해 주세요")
                    print("Fail to send")
                } else {
                    self.sendEmailButton.isEnabled = false
                    self.dismiss(animated: true)
                    print("send email")
                }
            }
        }
    }

    @objc func didTapCancleButton() {
        dismiss(animated: true)
    }
}

extension PopUpViewController {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if emailValidCheck(emailField) {
            emailValidCheckLabel.isHidden = true
            sendEmailButton.isEnabled = true
            sendEmailButton.backgroundColor = .mainPink
        } else {
            emailValidCheckLabel.isHidden = false
            sendEmailButton.isEnabled = false
            sendEmailButton.backgroundColor = .gray
        }
    }

}
