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
import CryptoKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

final class LogInViewController: BaseViewController {

    private let defaults = UserDefaults.standard
    
    var currentNonce: String?
    var currentAppleIdToken: String?

    private lazy var appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black).then {
        $0.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }

    private let loginTitleLabel = UILabel().then {
        $0.font = UIFont(name: "TsukimiRounded-Bold", size: 30)
        $0.textColor = .mainPink
        $0.textAlignment = .center
        $0.text = "SHUGGLE"
    }

    private let loginBoldLabel = UILabel().then {
        $0.font = UIFont(name: "TsukimiRounded-Bold", size: 15)
        $0.textColor = .textMainBlack
        $0.textAlignment = .center
        $0.text = "국내 최초의 지역 기반 사진활영 플랫폼 슈글!"
    }

    private let loginNormalLabel = UILabel().then {
        $0.font = UIFont(name: "TsukimiRounded-Bold", size:15)
        $0.textColor = .textHeadLineBlack
        $0.textAlignment = .center
        $0.text = "로그인하고 내 주변의 작가님들을 만나보세요"
    }

    private let emailField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        $0.autocorrectionType = .no
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
        $0.autocorrectionType = .no
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

    private let logInbutton = UIButton().then {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .mainPink
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("로그인", for: .normal)
    }

    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor( .textSubBlack, for: .normal)
        $0.backgroundColor = .clear
    }

    private let resetPasswordButton = UIButton().then {
        $0.setTitle("비밀번호 재설정", for: .normal)
        $0.setTitleColor( .textSubBlack, for: .normal)
        $0.backgroundColor = .clear
    }

    private let loginDividerFirst = UIView().then {
        $0.backgroundColor = .loginGray
    }

    private let loginDividerSecond = UIView().then {
        $0.backgroundColor = .loginGray
    }

    private let loginDividerText = UILabel().then {
        $0.textColor = .textSubBlack
        $0.font = .preferredFont(forTextStyle: .subheadline, weight: .bold)
        $0.textAlignment = .center
        $0.text = "소셜로그인"
    }
    
    override func render() {
        view.addSubviews(loginTitleLabel,loginBoldLabel,loginNormalLabel, emailField, passwordField, logInbutton, signUpButton, resetPasswordButton ,loginDividerFirst, loginDividerSecond, loginDividerText)
        view.addSubview(appleLoginButton)

        logInbutton.addTarget(self, action: #selector(didTapLogInbutton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(didTapResetPasswordButton), for: .touchUpInside)

        loginTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(60)
            $0.leading.trailing.equalToSuperview()
        }

        loginBoldLabel.snp.makeConstraints {
            $0.top.equalTo(loginTitleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
        }

        loginNormalLabel.snp.makeConstraints {
            $0.top.equalTo(loginBoldLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        emailField.snp.makeConstraints {
            $0.top.equalTo(loginNormalLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        passwordField.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        logInbutton.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        signUpButton.snp.makeConstraints {
            $0.top.equalTo(logInbutton.snp.bottom).offset(20)
            $0.trailing.equalTo(view.snp.centerX).offset(-40)
            $0.height.equalTo(30)
        }

        resetPasswordButton.snp.makeConstraints {
            $0.top.equalTo(logInbutton.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.centerX).offset(20)
            $0.height.equalTo(30)
        }

        loginDividerText.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(35)
            $0.centerX.equalToSuperview()
        }

        loginDividerFirst.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(loginDividerText.snp.leading).offset(-20)
            $0.centerY.equalTo(loginDividerText.snp.centerY)
        }

        loginDividerSecond.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.leading.equalTo(loginDividerText.snp.trailing).offset(20)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(loginDividerText.snp.centerY)
        }

        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(loginDividerText.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func goHome() {
        let viewController = TabbarViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }

    private func goProfile() {
        let viewController = LoginProfileViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    //Apple ID 승인 요청
    @objc private func handleAuthorizationAppleIDButtonPress() {
        let request = LoginManager.shared.createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    @objc private func didTapLogInbutton() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            makeAlert(title: "아이디 또는 비밀번호가 일치하지 않습니다.", message: "")
            print("Missing field data")
            return
        }

        Task { [weak self] in
            if let userId = await FirebaseManager.shared.signInUser(email: email, password: password) {
                await FirebaseManager.shared.updateUserToken(uid: userId)
                await CurrentUserDataManager.shared.saveUserDefault()
                self?.goHome()
            } else {
                makeAlert(title: "아이디 또는 비밀번호가 일치하지 않습니다.", message: "")
            }
        }
    }

    @objc private func didTapSignUpButton() {
        let viewController = SignUpViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func didTapResetPasswordButton() {
        let popUpViewController = PopUpViewController()
        popUpViewController.modalPresentationStyle = .overCurrentContext
        present(popUpViewController, animated: true)
    }
}

extension LogInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }


    // 사용자 인증 후 처리
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 현재 nonce가 설정되어 있는지 확인
            guard let nonce = LoginManager.shared.currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            // ID 토큰값을 검색
            guard let appleIDtoken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            //문자열로 변환
            guard let idTokenString = String(data: appleIDtoken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDtoken.debugDescription)")
                return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)

            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                guard (authDataResult?.user) != nil else { return }
                Task { [weak self] in
                    if (await FirebaseManager.shared.getUser()) != nil {
                        LoginManager.shared.currentAppleIdToken = idTokenString
                        self?.goHome()
                    } else {
                        LoginManager.shared.currentAppleIdToken = idTokenString
                        self?.goProfile()
                    }
                }

                if error != nil {
                    print(error?.localizedDescription ?? "error" as Any)
                    return
                }
            }
        }
    }
}
