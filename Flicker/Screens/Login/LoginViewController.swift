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

    fileprivate var currentNonce: String?

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

    private let lookAroundButton = UIButton().then {
        $0.setTitle("둘러보기", for: .normal)
        $0.setTitleColor(.textSubBlack, for: .normal)
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
        view.addSubviews(loginTitleLabel,loginBoldLabel,loginNormalLabel, emailField, passwordField, logInbutton, signUpButton, lookAroundButton, loginDividerFirst, loginDividerSecond, loginDividerText)
        view.addSubview(appleLoginButton)

        logInbutton.addTarget(self, action: #selector(didTapLogInbutton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        lookAroundButton.addTarget(self, action: #selector(didTapLookAroundButton), for: .touchUpInside)

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
            $0.top.equalTo(logInbutton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(90)
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }

        lookAroundButton.snp.makeConstraints {
            $0.top.equalTo(logInbutton.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(90)
            $0.width.equalTo(100)
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
    
    private func goHome() {
        let viewController = TabbarViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }

    private func goProfile() {
        let viewController = LoginProfileViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @available(iOS 13, *)
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        // 애플로그인은 사용자에게서 2가지 정보를 요구함
        request.requestedScopes = [.fullName, .email]

        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce

        return request
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    //Apple ID 승인 요청
    @objc private func handleAuthorizationAppleIDButtonPress() {
        let request = createAppleIDRequest()
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
            guard let userId = await FirebaseManager.shared.signInUser(email: email, password: password) else {
                return
            }
            await FirebaseManager.shared.updateUserToken(uid: userId)
            self?.goHome()
        }
        makeAlert(title: "아이디 또는 비밀번호가 일치하지 않습니다.", message: "")
    }

    @objc private func didTapSignUpButton() {
        let viewController = SignUpViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //TODO: 둘러보기 클릭하면 일단 메인 화면으로 가도록 설정은 해놨는데, 어떤 값을 줘서 입력을 하려할때, 혹은 기능을 쓰려할때 로그인이 필요하다고 뜨도록 해야 할 것 같습니다.
    @objc private func didTapLookAroundButton() {
        let viewController = TabbarViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
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
            guard let nonce = currentNonce else {
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

            FirebaseAuth.Auth.auth().signIn(with: credential) { (authDataResult, error) in
                if let user = authDataResult?.user {
                    //로그인 성공 시
                    self.goProfile()
                }

                if error != nil {
                    print(error?.localizedDescription ?? "error" as Any)
                    return
                }
            }
        }
    }
}

//임의로 생성되는 암호화 토큰이다.

private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}
