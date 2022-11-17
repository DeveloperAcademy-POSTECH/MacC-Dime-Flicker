//
//  RegionTagView.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class RegionTagView: UIButton {
    
    // MARK: - property
    
    let regionTagLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title3, weight: .regular)
        $0.textColor = .mainBlack
        $0.textAlignment = .center
        $0.text = "전체"
    }
    
    private let downImageView = UIImageView(image: ImageLiteral.btnDown).then {
        $0.tintColor = .mainBlack
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
        self.addSubviews(regionTagLabel, downImageView)
        
        regionTagLabel.snp.makeConstraints {
            $0.trailing.equalTo(downImageView.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
        
        downImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
