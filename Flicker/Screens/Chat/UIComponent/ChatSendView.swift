//
//  ChatSendView.swift
//  CobyTalk
//
//  Created by COBY_PRO on 2022/11/01.
//

import UIKit

import SnapKit
import Then

final class ChatSendView: UIView {
    
    // MARK: - Property
    
    let chatTextField = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 17.0)
        $0.textColor = UIColor.mainBlack
        $0.textAlignment = NSTextAlignment.left
        $0.dataDetectorTypes = UIDataDetectorTypes.all
        $0.isEditable = true
        $0.autocapitalizationType = .none
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 5)
    }
    
    let chatSendbutton = SendButton().then {
        $0.tintColor = .white
        $0.backgroundColor = .mainBlack
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
    }
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
        self.addSubviews(chatTextField, chatSendbutton)
        
        self.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.size.width)
            $0.bottom.equalTo(chatTextField.snp.bottom)
        }
        
        chatTextField.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.trailing.equalTo(chatSendbutton.snp.leading)
        }
        
        chatSendbutton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.trailing.equalToSuperview()
            $0.bottom.trailing.equalToSuperview().inset(5)
        }
    }
    
    private func configUI() {
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 20
    }
}
https://www.notion.so/coby5502/CobyTalk-c895ad474df4406aacab3104e274bbc1
