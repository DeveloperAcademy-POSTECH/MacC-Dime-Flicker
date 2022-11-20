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
        $0.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let artistLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.text = "작가님"
    }
    
    let artistInfoLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
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
        
        let width = artistThumnailImageView.bounds.width
        let height = artistThumnailImageView.bounds.height
        let sHeight: CGFloat = 100.0
        let shadow = UIColor.black.withAlphaComponent(0.7).cgColor

        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        artistThumnailImageView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSkeletonable = true
        self.artistThumnailImageView.isSkeletonable = true
        self.artistNameLabel.isSkeletonable = true
        self.artistLabel.isSkeletonable = true
        self.artistInfoLabel.isSkeletonable = true
        self.artistProfileImageView.isSkeletonable = true
    }
}
