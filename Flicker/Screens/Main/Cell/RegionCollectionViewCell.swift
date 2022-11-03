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
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
    }
    
    override func render() {
        contentView.addSubview(regionLabel)
        
        regionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func configUI() {
        clipsToBounds = true
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = .black.withAlphaComponent(0.15)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = .black
                self.regionLabel.textColor = .white
            } else {
                contentView.backgroundColor = .black.withAlphaComponent(0.15)
                self.regionLabel.textColor = .black
            }
        }
    }
}
