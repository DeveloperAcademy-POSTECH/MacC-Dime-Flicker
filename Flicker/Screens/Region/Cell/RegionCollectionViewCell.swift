//
//  RegionCollectionViewCell.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/03.
//

import UIKit

import SnapKit
import Then

final class RegionCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    
    let regionLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .semibold)
        $0.textAlignment = .center
    }
    
    override func render() {
        self.addSubview(regionLabel)
        
        regionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func configUI() {
        self.backgroundColor = .regionBlue.withAlphaComponent(0.15)
        self.regionLabel.textColor = .black
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
            self.backgroundColor = .regionBlue
            self.regionLabel.textColor = .white
        } else {
            self.backgroundColor = .regionBlue.withAlphaComponent(0.15)
            self.regionLabel.textColor = .black
        }
    }
}
