//
//  ThumnailCollectionViewCell.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/22.
//

import UIKit

import SkeletonView
import SnapKit
import Then

final class ThumnailCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    
    lazy var thumnailImageView = UIImageView().then {
        $0.backgroundColor = .gray002.withAlphaComponent(0.5)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.isSkeletonable = true
    }
    
    override func render() {
        contentView.addSubviews(thumnailImageView)
 
        thumnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
