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
    
    lazy var artistThumnailImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
    }
    
    let artistNameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let artistLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.text = "작가님"
    }
    
    let artistInfoLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
        $0.numberOfLines = 2
    }
    
    lazy var artistProfileImageView = UIImageView().then {
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
    }
    
    override func render() {
        contentView.addSubviews(artistNameLabel, artistLabel, artistInfoLabel, artistProfileImageView)
        
        artistNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.leading.equalToSuperview().inset(30)
        }
        
        artistLabel.snp.makeConstraints {
            $0.bottom.equalTo(artistNameLabel.snp.bottom).offset(-2)
            $0.leading.equalTo(artistNameLabel.snp.trailing).offset(8)
        }
        
        artistInfoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(artistLabel.snp.bottom).offset(10)
            $0.width.lessThanOrEqualTo(220)
        }
        
        artistProfileImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(30)
            $0.width.height.equalTo(60)
        }
    }
    
    override func configUI() {
        backgroundView = artistThumnailImageView
    }
}
