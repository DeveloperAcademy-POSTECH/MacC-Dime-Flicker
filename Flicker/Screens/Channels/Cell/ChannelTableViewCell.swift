//
//  ChannelTableViewCell.swift
//  CobyTalk
//
//  Created by Coby Kim on 2022/10/30.
//

import UIKit

import SnapKit
import Then

final class ChannelTableViewCell: BaseTableViewCell {
    
    // MARK: - property
    
    lazy var chatUserImageView = UIImageView().then {
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    lazy var chatUserNameLabel = UILabel().then {
        $0.textColor = .mainBlack
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
    }
    
    lazy var chatDateLabel = UILabel().then {
        $0.textColor = UIColor(hex: "#999999")
        $0.font = UIFont.systemFont(ofSize: 11)
    }
    
    lazy var chatLastLabel = UILabel().then {
        $0.textColor = .mainBlack
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    
    // MARK: - func
    
    override func render() {
        contentView.addSubviews(chatUserImageView, chatUserNameLabel, chatDateLabel, chatLastLabel)
        
        chatUserImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        chatUserNameLabel.snp.makeConstraints {
            $0.leading.equalTo(chatUserImageView.snp.trailing).offset(20)
            $0.top.equalToSuperview().inset(14)
        }
        
        chatDateLabel.snp.makeConstraints {
            $0.leading.equalTo(chatUserNameLabel.snp.trailing).offset(10)
            $0.top.equalToSuperview().inset(18)
        }
        
        chatLastLabel.snp.makeConstraints {
            $0.leading.equalTo(chatUserImageView.snp.trailing).offset(20)
            $0.bottom.equalToSuperview().inset(14)
        }
    }
}
