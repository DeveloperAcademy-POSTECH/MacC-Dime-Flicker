//
//  ProfileViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import SnapKit
import Then
import AuthenticationServices
import FirebaseAuth

final class ProfileViewController: BaseViewController {

    // MARK: - property
    private let signOutButton = UIButton().then {
        $0.backgroundColor = .mainBlack
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Sign Out", for: .normal)
        $0.addTarget(self, action: #selector(signOutButtonPress), for: .touchUpInside)
    }

    private let screenText = UILabel().then {
        $0.textColor = .red
        $0.text = "프로필"
    }
    
    override func render() {
        view.addSubview(screenText)
        view.addSubview(signOutButton)

        screenText.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        signOutButton.snp.makeConstraints {
            $0.top.equalTo(screenText.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }
}

extension ProfileViewController {

    private func goLogin() {
        let viewController = LogInViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }

    @objc private func signOutButtonPress() {

        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
        DispatchQueue.main.async {
            self.goLogin()
        }
    }
}
