//
//  MyChatTableViewCell.swift
//  CobyTalk
//
//  Created by COBY_PRO on 2022/11/01.
//

import UIKit

import SnapKit
import Then

final class MyChatTableViewCell: BaseTableViewCell {
    
    // MARK: - property
    
    var chatLabel = PaddingLabel().then {
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .mainPink
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    // MARK: - func
    
    override func render() {
        contentView.addSubviews(chatLabel)
        
        contentView.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.size.width)
            $0.bottom.equalTo(chatLabel.snp.bottom)
        }
        
        chatLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(5)
        }
    }
}
