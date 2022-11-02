//
//  RegisterGearsView.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/01.
//

import UIKit
import SnapKit
import Then

class RegisterGearsView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    private func render() {
        self.addSubviews(mainTitleLabel, subTitleLabel, bodyTitleLabel)
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(40)
            $0.leading.equalToSuperview().inset(40)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(45)
        }
        
        bodyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(45)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
