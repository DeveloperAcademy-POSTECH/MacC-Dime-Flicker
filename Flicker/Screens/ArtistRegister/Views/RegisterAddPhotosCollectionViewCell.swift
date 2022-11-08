//
//  RegisterAddPhotosCollectionViewCell.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/08.
//

import UIKit

class RegisterAddPhotosCollectionViewCell: UICollectionViewCell {
    
    // MARK: - view UI components
    let addImage = UIImageView().then {
        $0.image = UIImage(systemName: "plus.circle.fill")
        $0.tintColor = .textSubBlack
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .loginGray.withAlphaComponent(0.3)
        updateConstraints()
    }
    
    // MARK: - layout constraints
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    // MARK: - view configuration
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }
    
    private func render() {
        self.addSubview(addImage)
        
        addImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(self.addImage.snp.width).multipliedBy(1.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
