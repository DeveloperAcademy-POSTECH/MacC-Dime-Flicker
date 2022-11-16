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

    private let secondSubLabel = UILabel().makeBasicLabel(labelText: "SUGGLE 아이디 비밀번호를 한번 더 입력해주세요.", textColor: .textSubBlack, fontStyle: .callout, fontWeight: .bold)

    private let certifiedButton = UIButton().then {
        $0.backgroundColor = .mainPink
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("확인", for: .normal)
        $0.layer.cornerRadius = 15
    }

    override func render() {

        view.addSubviews(navigationDivider, mainLabel, firstSubLabel, secondSubLabel, certifiedButton)

        certifiedButton.addTarget(self, action: #selector(didTapSignInbutton), for: .touchUpInside)

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

    @objc private func didTapSignInbutton() {
    }

}
