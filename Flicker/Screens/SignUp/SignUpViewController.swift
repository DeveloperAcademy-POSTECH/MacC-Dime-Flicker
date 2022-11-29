//
//  SignUpViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import SnapKit
import Then

final class SignUpViewController: BaseViewController {

    private let didTapSignUpEmail = true

    private let signUpTitleLabel = UILabel().makeBasicLabel(labelText: "반가워요!", textColor: .black, fontStyle: .largeTitle, fontWeight: .bold)


    private let signUpLabel = UILabel().then {
        $0.tintColor = .black
        $0.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.numberOfLines = 2
        $0.text = "로그인에 사용될 이메일과 비밀번호를 설정해주세요"
    }

    private let emailField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)
        ]

        $0.tag = 0
        $0.backgroundColor = .loginGray
        $0.attributedPlaceholder = NSAttributedString(string: "이메일 주소", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
        $0.autocorrectionType = .no

    }

    private let emailValidCheckLabel = UILabel().makeBasicLabel(labelText: "이메일 주소를 확인해 주세요.", textColor: .red, fontStyle: .subheadline, fontWeight: .light)

    private let passwordField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        $0.tag = 1
        $0.backgroundColor = .loginGray
        $0.attributedPlaceholder = NSAttributedString(string: "비밀번호 (최소 6자 이상)", attributes: attributes)
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.isSecureTextEntry = true
        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
        $0.autocorrectionType = .no
    }

    private let passwordValidCheckLabel = UILabel().makeBasicLabel(labelText: "비밀번호는 6자리 이상으로 작성해주세요.", textColor: .red, fontStyle: .subheadline, fontWeight: .light)

    private let passwordSameCheckField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        $0.tag = 2
        $0.backgroundColor = .loginGray
        $0.attributedPlaceholder = NSAttributedString(string: "비밀번호 확인", attributes: attributes)
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.isSecureTextEntry = true
        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
        $0.autocorrectionType = .no
    }

    private let passwordSameCheckLabel = UILabel().makeBasicLabel(labelText: "비밀번호가 일치하지 않습니다.", textColor: .red, fontStyle: .subheadline, fontWeight: .light)

    private lazy var signUpButton = UIButton().then {
        $0.backgroundColor = .loginGray
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("다음", for: .normal)
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }

    override func render() {
        emailField.delegate = self
        passwordField.delegate = self
        passwordSameCheckField.delegate = self

        emailField.returnKeyType = .done
        passwordField.returnKeyType = .done
        passwordSameCheckField.returnKeyType = .done

        emailValidCheckLabel.isHidden = true
        passwordValidCheckLabel.isHidden = true
        passwordSameCheckLabel.isHidden = true

        view.addSubviews(emailValidCheckLabel ,signUpTitleLabel, signUpLabel, emailField, passwordField, signUpButton, passwordSameCheckField, passwordValidCheckLabel, passwordSameCheckLabel)

        signUpTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalToSuperview().inset(30)
        }

        signUpLabel.snp.makeConstraints {
            $0.top.equalTo(signUpTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(30)
            $0.width.equalTo(DeviceFrame.screenWidth * 0.63)
        }

        emailField.snp.makeConstraints {
            $0.top.equalTo(signUpLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.07)
        }

        emailValidCheckLabel.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(40)
        }

        passwordField.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(35)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.07)
        }

        passwordValidCheckLabel.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(40)
        }

        passwordSameCheckField.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(35)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.07)
        }

        passwordSameCheckLabel.snp.makeConstraints {
            $0.top.equalTo(passwordSameCheckField.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(40)
        }

        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.065)
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }

    @objc private func didTapSignUpButton() {
        let viewController = LoginProfileViewController()
        guard let email = emailField.text, emailValidCheck(emailField),
              let password = passwordField.text, passwordValidCheck(passwordField),
              let passwordCheck = passwordSameCheckField.text, passwordSameCheck(passwordField, passwordSameCheckField) else {
            print("Missing field data")
            return
        }

        viewController.authEmail = email
        viewController.authPassword = passwordCheck
        viewController.isSignUpEmail = self.didTapSignUpEmail
        
        Task { [weak self] in
            guard let isExistEmail = await FirebaseManager.shared.isEmailSameExist(Email: emailField.text ?? "") else { return }
            if isExistEmail {
                makeAlert(title: "이미 사용중인 메일 주소입니다.", message: "")
            } else {
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension SignUpViewController {
    override func textFieldDidEndEditing(_ textField: UITextField) {
        //이메일 유효성 검사 후 검사에 통과하면 아무 표시도 하지않고 검사에 통과하지 못한다면 라벨을 통해 이메일을 확인하라는 표시를 해줌
        switch textField.tag {
        case 0:
            if !emailValidCheck(emailField) {
                emailValidCheckLabel.isHidden = false

            } else {
                emailValidCheckLabel.isHidden = true
            }
        case 1:
            if !passwordValidCheck(passwordField) {
                passwordValidCheckLabel.isHidden = false
                
            } else {
                passwordValidCheckLabel.isHidden = true
            }
        case 2:
            if !passwordSameCheck(passwordField, passwordSameCheckField) {
                passwordSameCheckLabel.isHidden = false
            } else {
                passwordSameCheckLabel.isHidden = true
            }
        default: return
        }

        if ( emailValidCheck(emailField) && passwordValidCheck(passwordField) && passwordSameCheck(passwordField, passwordSameCheckField)) {
            signUpButton.backgroundColor = .mainPink
        } else {
            signUpButton.backgroundColor = .loginGray
        }
    }
}
