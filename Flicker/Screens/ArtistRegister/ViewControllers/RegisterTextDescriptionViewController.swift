//
//  RegisterTextDescriptionViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/02.
//

import UIKit
import SnapKit
import Then

    // TODO: (다음 버전에..)
final class RegisterTextDescriptionViewController: UIViewController {

    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "자기 소개"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
        $0.text = "미래의 클라이언트에게 어필할 멘트입니다."
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.text = "촬영 경험과 자신의 촬영 스타일을 적어주세요!"
    }
    
    private let desriptionTextView = UITextView().then {
        $0.clipsToBounds = true
        $0.isScrollEnabled = false
        $0.dataDetectorTypes = .all
        $0.textColor = .textSubBlack
        $0.autocorrectionType = .no
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .loginGray.withAlphaComponent(0.5)
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        $0.font = .preferredFont(forTextStyle: .callout, weight: .regular)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        render()
    }
    
    // MARK: - layout constraints
    private func render() {
        view.addSubviews(mainTitleLabel, subTitleLabel, bodyTitleLabel, desriptionTextView)
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
        }
        
        bodyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(30)
        }
        
        desriptionTextView.snp.makeConstraints {
            $0.top.equalTo(bodyTitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(UIScreen.main.bounds.height/2.5)
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        desriptionTextView.layer.cornerRadius = view.bounds.width/22
    }

}
