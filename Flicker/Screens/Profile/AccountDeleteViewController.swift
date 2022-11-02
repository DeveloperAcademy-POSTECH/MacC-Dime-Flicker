//
//  AccountDeleteViewController.swift
//  Flicker
//
//  Created by Taehwan Kim on 2022/11/01.
//

import UIKit
import SnapKit
import Then

class AccountDeleteViewController: BaseViewController {
    private let topTitle = UILabel().then {
        $0.textColor = .black
        $0.text = "회원탈퇴"
        $0.font = .boldSystemFont(ofSize: 18)
    }
    private let topBar = UIView().then {
        $0.backgroundColor = .systemGray
    }
    private let text1 = UILabel().then {
        $0.textColor = .black
        $0.text = "고마웠어요!"
        $0.font = .boldSystemFont(ofSize: 32)
    }
    private let text2 = UILabel().then {
        $0.textColor = .black
        $0.text = "순간을 기념하고 싶을 때 \n언제든 다시 찾아주세요!"
        $0.numberOfLines = 2
        $0.font = .boldSystemFont(ofSize: 20)
    }
    private let text3 = UILabel().then {
        $0.textColor = .black
        $0.text = "SHUGGLE"
        // TODO: 여기 폰트 츠키미로 바꿔 넣어야함
        $0.font = .boldSystemFont(ofSize: 32)
    }
    private lazy var button = UIButton().then {
        $0.addTarget(self, action: #selector(btnPressed(_:)), for: .touchUpInside)
        $0.backgroundColor = .systemPink
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
    }
    @objc func btnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "정말 탈퇴하시겠어요?", message: "회원님의 가입정보가 삭제되며 \n 복구가 불가능합니다.", preferredStyle: .alert)
        // TODO: yes에는 파이어베이스에서 사용자의 id를 조회하고 해당하는 데이터를 모두 삭제해야한다.
        // MARK: 법에 의해 몇몇 데이터는 최소 3개월에서 최대 5년간 우리가 데이터를 지우면 안 된다.
        // MARK: 우리가 현재 상당한 수준의 익명화로 서비스를 진행할거라 고려가 필요
        let yes = UIAlertAction(title: "확정", style: .default, handler: nil)
        // TODO: NO를 누르면 해당 뷰를 탈출하여 ProfileSettingView로 돌아갈듯?
        let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
    }
    override func render() {
        view.addSubviews(topTitle, topBar, text1, text2, text3, button)
        topTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).multipliedBy(1.2)
        }
        topBar.snp.makeConstraints {
            $0.top.equalTo(topTitle.snp.bottom).multipliedBy(1.1)
            $0.bottom.equalTo(topBar.snp.top).offset(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        text1.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).multipliedBy(2.5)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        text2.snp.makeConstraints {
            $0.top.equalTo(text1.snp.bottom).multipliedBy(1.1)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        text3.snp.makeConstraints {
            $0.top.equalTo(text2.snp.bottom).multipliedBy(1.15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        button.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalToSuperview().dividedBy(13)
        }
    }
    
}
