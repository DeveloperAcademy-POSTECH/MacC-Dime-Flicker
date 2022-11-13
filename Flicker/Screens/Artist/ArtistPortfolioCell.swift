//
//  ArtistCell.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/29.
//
import UIKit
import Then

class ArtistPortfolioCell: UICollectionViewCell {
    static let identifier =
    "ArtistPortfolioCell"

    let imageView: UIImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)

        // 플레이스 홀더 역할을 하는 색상
        contentView.backgroundColor = .systemGray5
        
        self.addSubview(imageView)
        imageView.frame = contentView.bounds
    }

    required init? (coder: NSCoder) {
        fatalError("init (coder:) has not been implemented" )
    }
}
