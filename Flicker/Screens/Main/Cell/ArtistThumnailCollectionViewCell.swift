//
//  ArtistThumnailCollectionViewCell.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/03.
//

import UIKit

import SnapKit
import Then

final class ArtistThumnailCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    
    let artistNameLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    override func render() {
        contentView.addSubview(artistNameLabel)
        
        artistNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.leading.equalToSuperview().inset(30)
        }
    }
    
    override func configUI() {
        clipsToBounds = true
        backgroundColor = .black
        layer.masksToBounds = false
        layer.cornerRadius = 20
    }
}
