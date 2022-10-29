//
//  ArtistCell.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/29.
//
import UIKit
import Foundation

class MyCollectionViewCell: UICollectionViewCell {
    static let identifier =
    "MyCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray5
    }

    required init? (coder: NSCoder) {
        fatalError("init (coder:) has not been implemented" )
    }
}
