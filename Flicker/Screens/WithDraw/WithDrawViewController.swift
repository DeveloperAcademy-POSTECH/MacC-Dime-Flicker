//
//  SignOutViewController.swift
//  Flicker
//
//  Created by 김연호 on 2022/11/14.
//

import UIKit

import SnapKit
import Then
import AuthenticationServices
import Firebase
import FirebaseAuth
import FirebaseFirestore

final class WithDrawViewController: BaseViewController {
    
    private let mainLabel = UILabel().makeBasicLabel(labelText: "고마웠어요!", textColor: .textMainBlack, fontStyle: .largeTitle, fontWeight: .bold)
    
    private let subLabel = UILabel().makeBasicLabel(labelText: "순간을 기념하고 싶을 때 언제든 다시 찾아주세요!", textColor: .textSubBlack, fontStyle: .title3, fontWeight: .bold).then {
        $0.numberOfLines = 2
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: "TsukimiRounded-Bold", size: 30)
        $0.textColor = .mainPink.withAlphaComponent(0.6)
        $0.textAlignment = .center
        $0.text = "SHUGGLE"
    }
    
    private let signOutButton = UIButton().then {
        $0.backgroundColor = .mainPink
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("로그인화면으로 돌아가기", for: .normal)
        $0.layer.cornerRadius = (DeviceFrame.screenHeight * 0.077) * 0.35
    }
    
    override func render() {
        
        view.addSubviews(mainLabel, subLabel, titleLabel, signOutButton)
        
        signOutButton.addTarget(self, action: #selector(didTapSignInbutton), for: .touchUpInside)

        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(180)
            $0.leading.equalToSuperview().inset(45)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(45)
            $0.width.equalTo(DeviceFrame.screenWidth * 0.64)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.08)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(40)
            $0.trailing.equalToSuperview().inset(45)
        }
        
        signOutButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(DeviceFrame.screenHeight * 0.077)
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
        tabBarController?.tabBar.isHidden = true
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "회원탈퇴"
    }
    
    @objc private func didTapSignInbutton() {
        DispatchQueue.main.async {
            self.goLogin()
        }
    }
}
