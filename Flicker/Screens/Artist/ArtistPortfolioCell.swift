//
//  ArtistCell.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/29.
//
import UIKit
import Then
import SkeletonView

final class ArtistPortfolioCell: UICollectionViewCell {

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    let imageView: UIImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isSkeletonable = true
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
