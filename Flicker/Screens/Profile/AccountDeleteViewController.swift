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
        $0.textColor = .TextHeadlineBlack
        $0.text = "회원탈퇴"
        $0.font = .preferredFont(forTextStyle: .headline, weight: .regular)
    }
//    private let navBar = UINavigationBar(x:0, y:0, width: view.frame.size.width, height: 44).then {
//        $0.frame(x: 0, y: 0, width: view.frame.size.width)
//    }
    private let topBar = UIView().then {
        $0.backgroundColor = .systemGray
    }
    private let textFirst = UILabel().then {
        $0.textColor = .TextMainBlack
        $0.text = "고마웠어요!"
        $0.font = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
    }
    private let textSecond = UILabel().then {
        $0.textColor = .TextSubBlack
        $0.text = "순간을 기념하고 싶을 때 \n언제든 다시 찾아주세요!"
        $0.numberOfLines = 2
        $0.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
    }
    private let textThird = UILabel().then {
        $0.textColor = .MainTintColor
        $0.text = "SHUGGLE"
        // TODO: 여기 폰트 츠키미로 바꿔 넣어야함
        $0.font = .preferredFont(forTextStyle: .title1, weight: .bold)
    }
    private lazy var button = UIButton().then {
        $0.addTarget(self, action: #selector(btnPressed(_:)), for: .touchUpInside)
        $0.backgroundColor = .MainTintColor
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = self.view.bounds.width / 16
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
        // createNavigationBar()
        view.addSubviews(topTitle, topBar, textFirst, textSecond, textThird, button)
        topTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).multipliedBy(1.2)
        }
        topBar.snp.makeConstraints {
            $0.top.equalTo(topTitle.snp.bottom).multipliedBy(1.1)
            //$0.top.equalToSuperview().inset(100)
            $0.bottom.equalTo(topBar.snp.top).offset(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        textFirst.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).multipliedBy(2.5)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        textSecond.snp.makeConstraints {
            $0.top.equalTo(textFirst.snp.bottom).multipliedBy(1.1)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        textThird.snp.makeConstraints {
            $0.top.equalTo(textSecond.snp.bottom).multipliedBy(1.15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        button.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalToSuperview().dividedBy(13)
        }
    }
    private func createNavigationBar() {
        let width = self.view.frame.width
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationItem.title = "회원 탈퇴"
        view.backgroundColor = .white
        navigationBar.setItems([navigationItem], animated: false)
        self.view.addSubview(navigationBar)
    }
}
