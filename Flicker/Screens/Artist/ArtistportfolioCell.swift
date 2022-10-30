//
//  ArtistCell.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/29.
//
import UIKit
import Foundation

class ArtistPortfolioCell: UICollectionViewCell {
    static let identifier =
    "ArtistPortfolioCell"

    let imageView: UIImageView = UIImageView(frame: .zero)
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)

        // configuration
        contentView.backgroundColor = .systemGray5

        // addsubview
        self.addSubview(imageView)

        // layout
        imageView.frame = contentView.bounds
    }

    required init? (coder: NSCoder) {
        fatalError("init (coder:) has not been implemented" )
    }
}
