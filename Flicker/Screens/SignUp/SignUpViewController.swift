//
//  SignUpViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import SnapKit
import Then

class SignUpViewController: BaseViewController {
    
    private let signUpTitleLabel = UILabel().then {
        $0.tintColor = .black
        $0.font = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "반가워요!"
    }
    
    private let signUpLabel = UILabel().then {
        $0.tintColor = .black
        $0.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        $0.numberOfLines = 2
        $0.text = "로그인에 사용될 이메일과 비밀번호를 설정해주세요"
    }
    
    private let emailField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        
        $0.backgroundColor = .loginGray
        $0.attributedPlaceholder = NSAttributedString(string: "이메일 주소", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
    }
    
    private let passwordField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        
        $0.backgroundColor = .loginGray
        $0.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: attributes)
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.isSecureTextEntry = true
        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
    }
    
    private let signUpButton = UIButton().then {
        $0.backgroundColor = .loginGray
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("완료", for: .normal)
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    
    private let navigationDivider = UIView().then {
        $0.backgroundColor = .loginGray
    }
    
    override func render() {
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubviews(signUpTitleLabel, signUpLabel, emailField, passwordField, signUpButton, navigationDivider)
        
        
        signUpTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalToSuperview().inset(30)
        }
        
        signUpLabel.snp.makeConstraints {
            $0.top.equalTo(signUpTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(30)
            $0.width.equalTo(250)
        }
        
        emailField.snp.makeConstraints {
            $0.top.equalTo(signUpLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        passwordField.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        navigationDivider.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        title = "프로필 입력"
        
    }
    
    @objc private func didTapSignUpButton() {
        let viewController = LoginProfileViewController()
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            print("Missing field data")
            return
        }
        //TODO: email값을 다음 뷰에 넘겨줘 다음 뷰에서 email값과 name값을 파베로 넘겨줘야 함
        Task { [weak self] in
            await FirebaseManager.shared.createNewAccount(email: email, password: password)
            //            await FirebaseManager.shared.storeUserInformation(email: email, name: name)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
    extension SignUpViewController {
        override func textFieldDidEndEditing(_ textField: UITextField) {
            if !(emailField.text!.isEmpty || passwordField.text!.isEmpty) {
                signUpButton.backgroundColor = .mainPink
            } else {
                signUpButton.backgroundColor = .loginGray
            }
        }
    }
