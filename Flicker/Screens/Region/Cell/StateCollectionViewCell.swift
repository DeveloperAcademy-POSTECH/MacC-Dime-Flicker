//
//  StateCollectionViewCell.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class StateCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    
    let stateLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .semibold)
        $0.textAlignment = .center
    }
    
    override func render() {
        self.addSubview(stateLabel)
        
        stateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func configUI() {
        self.backgroundColor = .mainBlack.withAlphaComponent(0.15)
        self.stateLabel.textColor = .black
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
    }
    
    override var isSelected: Bool {
        willSet {
            self.setSelected(newValue)
        }
    }
    
    private func setSelected(_ selected: Bool) {
        if selected {
            self.backgroundColor = .mainBlack
            self.stateLabel.textColor = .white
        } else {
            self.backgroundColor = .mainBlack.withAlphaComponent(0.15)
            self.stateLabel.textColor = .black
        }
    }
}
