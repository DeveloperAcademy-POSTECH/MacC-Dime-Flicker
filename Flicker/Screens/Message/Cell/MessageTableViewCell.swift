//
//  MessageTableViewCell.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import SnapKit
import Then

class MessageTableViewCell: BaseTableViewCell {
    
    // MARK: - property
    
    lazy var chatUserImageView = UIImageView().then {
        let url = URL(string: "https://picsum.photos/600/600/?random")
        $0.load(url: url!)
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
    
    lazy var goodImageView = UIImageView().then {
        let url = URL(string: "https://picsum.photos/600/600/?random")
        $0.load(url: url!)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    // MARK: - func
    
    override func render() {
        contentView.addSubviews(chatUserImageView, chatUserNameLabel, chatDateLabel, chatLastLabel, goodImageView)
        
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
        
        goodImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
