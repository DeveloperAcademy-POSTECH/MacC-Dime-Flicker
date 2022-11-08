//
//  RegisterPortfolioImageCell.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/08.
//

import UIKit

class RegisterPortfolioImageCell: UICollectionViewCell {
    
    // MARK: - view UI components
    let photoImage = UIImageView().then {
        $0.image = UIImage(systemName: "person.fill")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateConstraints()
    }
    
    // MARK: - layout constraints
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    private func render() {
        self.addSubview(photoImage)
        
        photoImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.center.equalToSuperview()
            $0.height.equalTo(self.photoImage.snp.width).multipliedBy(1.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
