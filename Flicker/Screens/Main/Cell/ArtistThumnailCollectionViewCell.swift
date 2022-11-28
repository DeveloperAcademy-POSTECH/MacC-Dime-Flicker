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
        $0.backgroundColor = .gray002.withAlphaComponent(0.5)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
    }
    
    let artistNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        $0.textColor = .white
        $0.text = "홍길동"
    }
    
    let artistTagLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        $0.textColor = .white.withAlphaComponent(0.9)
        $0.text = "작가에 대한 설명 태그"
    }
    
    lazy var artistProfileImageView = UIImageView().then {
        $0.backgroundColor = .gray002
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
    }
    
    override func render() {
        contentView.addSubviews(artistThumnailImageView, artistProfileImageView, artistTagLabel, artistNameLabel)
 
        artistThumnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        artistProfileImageView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(20)
            $0.width.height.equalTo(60)
        }
        
        artistTagLabel.snp.makeConstraints {
            $0.leading.equalTo(artistProfileImageView.snp.trailing).offset(15)
            $0.bottom.equalToSuperview().inset(25)
            $0.width.lessThanOrEqualTo(UIScreen.main.bounds.size.width - 180)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.leading.equalTo(artistProfileImageView.snp.trailing).offset(15)
            $0.bottom.equalTo(artistTagLabel.snp.top).offset(-4)
        }
    }
    
    override func configUI() {
        self.artistThumnailImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let width: CGFloat = UIScreen.main.bounds.size.width - 40
        let height: CGFloat = 300.0
        let sHeight: CGFloat = 150.0
        let shadow = UIColor.black.withAlphaComponent(0.8).cgColor

        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        self.artistThumnailImageView.layer.insertSublayer(bottomImageGradient, at: 0)
        
        self.isSkeletonable = true
        self.artistThumnailImageView.isSkeletonable = true
        self.artistProfileImageView.isSkeletonable = true
        self.artistNameLabel.isSkeletonable = true
        self.artistTagLabel.isSkeletonable = true
    }
}
