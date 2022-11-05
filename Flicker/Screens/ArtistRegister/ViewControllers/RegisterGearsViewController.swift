//
//  RegisterGearsViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/02.
//

import UIKit
import SnapKit
import Then

final class RegisterGearsViewController: UIViewController {
    
    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "장비 정보"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .semibold)
        $0.text = "사용하시는 카메라에 대해 말씀해주세요!"
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium)
        $0.text = "메인으로 쓰는 카메라 바디와 렌즈를 하나씩만 적어주세요."
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    // MARK: - layout constraints
    private func render() {
        view.addSubviews(mainTitleLabel, subTitleLabel, bodyTitleLabel)
        
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
    }

}
