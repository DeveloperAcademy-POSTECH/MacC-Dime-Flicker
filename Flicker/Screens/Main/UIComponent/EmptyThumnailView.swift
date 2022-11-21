//
//  EmptyThumnailView.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/22.
//

import UIKit

import SnapKit
import Then

final class EmptyThumnailView: UIView {
    
    // MARK: - property
    
    private let emptyImage = UIImageView(image: ImageLiteral.appLogo)
    
    private let emptyLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        $0.textColor = .mainPink
        $0.textAlignment = .center
        $0.text = "작가가 없습니다."
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        self.addSubviews(emptyImage, emptyLabel)
        
        emptyImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
            $0.width.height.equalTo(80)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
