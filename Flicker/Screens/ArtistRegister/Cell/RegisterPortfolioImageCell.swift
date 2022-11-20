//
//  RegisterPortfolioImageCell.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/08.
//

import UIKit
import SnapKit
import Then

class RegisterPortfolioImageCell: UICollectionViewCell {
    
    // MARK: - view UI components
    let photoImage = UIImageView().then {
        $0.layer.borderColor = UIColor.systemPink.cgColor
        $0.layer.borderWidth = 4
        $0.image = UIImage(systemName: "photo")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var mainPhotoMarkLabel = UILabel().makeBasicLabel(labelText: "대표 사진", textColor: .white, fontStyle: .footnote, fontWeight: .bold).then {
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.backgroundColor = .systemPink.withAlphaComponent(0.7)
        $0.isHidden = true
    }

    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateConstraints()
        layoutSubviews()
    }
    
    // MARK: - layout constraints
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainPhotoMarkLabel.layer.cornerRadius = 7
    }
    
    private func render() {
        self.addSubviews(photoImage, mainPhotoMarkLabel)
        
        photoImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.center.equalToSuperview()
            $0.height.equalTo(self.photoImage.snp.width).multipliedBy(1.0)
        }
        
        mainPhotoMarkLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
            $0.height.equalToSuperview().dividedBy(6)
            $0.width.equalToSuperview().dividedBy(1.7)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
