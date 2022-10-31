//
//  LoginViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import SnapKit
import Then
import AuthenticationServices

class LogInViewController: BaseViewController {

    private let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline).then {
        $0.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }
    
//    private let loginLabel = UILabel().then {
//        $0.textAlignment = .center
//        $0.text = "로그인"
//        $0.font = .systemFont(ofSize: 24, weight: .semibold)
//    }
    
//    private let emailField = UITextField().then {
//        let attributes = [
//            NSAttributedString.Key.foregroundColor : UIColor.mainBlack,
//            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular)
//        ]
//
//        $0.backgroundColor = .white
//        $0.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributes)
//        $0.autocapitalizationType = .none
//        $0.layer.cornerRadius = 12
//        $0.layer.masksToBounds = true
//        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        $0.leftViewMode = .always
//        $0.clipsToBounds = false
//        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
//    }
    
//    private let passwordField = UITextField().then {
//        let attributes = [
//            NSAttributedString.Key.foregroundColor : UIColor.mainBlack,
//            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular)
//        ]
//
//        $0.backgroundColor = .white
//        $0.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
//        $0.layer.cornerRadius = 12
//        $0.layer.masksToBounds = true
//        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
//        $0.leftViewMode = .always
//        $0.clipsToBounds = false
//        $0.isSecureTextEntry = true
//        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
//    }
    
//    private let logInbutton = UIButton().then {
//        $0.backgroundColor = .mainBlack
//        $0.setTitleColor(.white, for: .normal)
//        $0.setTitle("Log In", for: .normal)
//    }
//
//    private let signUpButton = UIButton().then {
//        $0.backgroundColor = .mainBlack
//        $0.setTitleColor(.white, for: .normal)
//        $0.setTitle("Sign Up", for: .normal)
//    }
    
//    private let logInErrorLabel = UILabel().then {
//        $0.textAlignment = .center
//        $0.text = "Failed to Log In"
//        $0.font = .systemFont(ofSize: 24, weight: .semibold)
//        $0.textColor = .mainBlack
//    }
    
    override func render() {
//        view.addSubviews(loginLabel, emailField, passwordField, logInbutton, signUpButton, logInErrorLabel)

        view.addSubview(appleLoginButton)

//        logInbutton.addTarget(self, action: #selector(didTapLogInbutton), for: .touchUpInside)
//        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
//
//        logInErrorLabel.isHidden = true

        appleLoginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

//        loginLabel.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
//            $0.leading.trailing.equalToSuperview()
//        }
//
//        emailField.snp.makeConstraints {
//            $0.top.equalTo(loginLabel.snp.bottom).offset(50)
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(60)
//        }
//
//        passwordField.snp.makeConstraints {
//            $0.top.equalTo(emailField.snp.bottom).offset(10)
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(60)
//        }
//
//        logInbutton.snp.makeConstraints {
//            $0.top.equalTo(passwordField.snp.bottom).offset(20)
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(60)
//        }
//
//        signUpButton.snp.makeConstraints {
//            $0.top.equalTo(logInbutton.snp.bottom).offset(10)
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(60)
//        }
        
//        logInErrorLabel.snp.makeConstraints {
//            $0.top.equalTo(signUpButton.snp.bottom).offset(30)
//            $0.leading.trailing.equalToSuperview().inset(20)
//        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        emailField.becomeFirstResponder()
    }
    
//    @objc private func didTapLogInbutton() {
//        guard let email = emailField.text, !email.isEmpty,
//              let password = passwordField.text, !password.isEmpty else {
//            logInErrorLabel.isHidden = false
//            print("Missing field data")
//            return
//        }
//
//        Task { [weak self] in
//            guard let userId = await FirebaseManager.shared.signInUser(email: email, password: password) else {
//                self?.logInErrorLabel.isHidden = false
//                return
//            }
//            await FirebaseManager.shared.updateUserToken(uid: userId)
//            self?.goHome()
//        }
//    }
    
//    @objc private func didTapSignUpButton() {
//        let viewController = SignUpViewController()
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
    
    private func goHome() {
        let viewController = TabbarViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //Apple ID 승인 요청
    @objc private func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        //애플에서 제공받을 수 있도록 요청할 수 있는건 이름과 이메일 뿐임
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

}

extension LogInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }


// 사용자 인증 후 처리
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            //비밀번호 및 페이스ID인증
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // 앱 내부의 계정에서 사용하는 값
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            saveUserInKeychain(userIdentifier)
            self.goHome()

            //iCloud의 패스워드 연동
        case let passwordCredental as ASPasswordCredential:
            let username = passwordCredental.user
            let password = passwordCredental.password
            self.goHome()

        default:
            break
        }
    }
// 사용자 인증 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("인증이 실패 되었습니다.")
        // TODO: 다시 로그인 뷰가 로딩되어 돌아가는 로직 구현?
    }

    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.dime.Flicker", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
}
