//
//  InputPasswordViewController.swift
//  Flicker
//
//  Created by 김연호 on 2022/11/16.
//
import UIKit

import SnapKit
import Then
import AuthenticationServices
import Firebase
import FirebaseAuth

final class InputPasswordViewController: BaseViewController {

    private let navigationDivider = UIView().then {
        $0.backgroundColor = .loginGray
    }

    private let mainLabel = UILabel().makeBasicLabel(labelText: "아이디 재인증", textColor: .textMainBlack, fontStyle: .title3, fontWeight: .bold)

    private let firstSubLabel = UILabel().makeBasicLabel(labelText: "개인정보를 안전하게 보호하기 위하여", textColor: .textSubBlack, fontStyle: .callout, fontWeight: .bold)

    private let secondSubLabel = UILabel().makeBasicLabel(labelText: "SHUGGLE 아이디 비밀번호를 한번 더 입력해주세요.", textColor: .textSubBlack, fontStyle: .callout, fontWeight: .bold)

    private let passwordField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        $0.autocorrectionType = .no
        $0.backgroundColor = .loginGray
        $0.attributedPlaceholder = NSAttributedString(string: "비밀번호 입력", attributes: attributes)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.isSecureTextEntry = true
        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
    }

    private let certifiedButton = UIButton().then {
        $0.backgroundColor = .mainPink
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("확인", for: .normal)
        $0.layer.cornerRadius = 10
    }

    override func render() {

        view.addSubviews(navigationDivider, mainLabel, firstSubLabel, secondSubLabel, passwordField,certifiedButton)

        certifiedButton.addTarget(self, action: #selector(didTapReAuthButton), for: .touchUpInside)

        navigationDivider.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }

        mainLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).offset(-250)
            $0.leading.equalToSuperview().inset(20)
        }

        firstSubLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(view.snp.centerX)
        }

        secondSubLabel.snp.makeConstraints {
            $0.top.equalTo(firstSubLabel.snp.bottom).offset(5)
            $0.centerX.equalTo(view.snp.centerX)
        }

        passwordField.snp.makeConstraints {
            $0.top.equalTo(secondSubLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        certifiedButton.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "정보관리"
    }

    @objc private func didTapReAuthButton() {
        let viewController = ProfileSettingViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
//    //사용자 재인증 함수, 이메일은 파베에서 가져오고 비밀번호는 사용자가 입력 한 후, 비밀번호가 틀릴 시 재입력요구, 성공하면 ProfileSettingView로 넘어감
//    private func reAuthUser() {
//        let user = Auth.auth().currentUser
//        let userEmail = user?.email
//        let userPw = passwordField.text
//        let credential = EmailAuthProvider.credential(withEmail: userEmail!, password: userPw!)
//
//        user?.reauthenticate(with: credential) { _,error  in
//            if let error = error {
//                print(error)
//                self.makeAlert(title: "비밀번호를 확인해주세요", message: "")
//            } else {
//                let viewController = ProfileSettingViewController()
//                self.navigationController?.pushViewController(viewController, animated: true)
//            }
//        }
//    }
}
