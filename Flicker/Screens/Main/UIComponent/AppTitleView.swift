//
//  AppTitleView.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class AppTitleView: UIView {
    
    // MARK: - property
    
    private let appTitleLabel = UILabel().then {
        $0.font = UIFont(name: "TsukimiRounded-Bold", size: 30)
        $0.textColor = .mainPink
        $0.textAlignment = .center
        $0.text = "SHUGGLE!"
    }
    
    private let appLogo = UIImageView(image: ImageLiteral.appLogo)
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        self.addSubviews(appTitleLabel, appLogo)
        
        appTitleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        appLogo.snp.makeConstraints {
            $0.leading.equalTo(appTitleLabel.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
    }
}
