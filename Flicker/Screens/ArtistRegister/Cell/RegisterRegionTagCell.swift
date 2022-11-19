//
//  RegisterRegionTagCell.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/01.
//

import UIKit
import SnapKit
import Then

    // MARK: - RegisterRegionView 에 들어가는 지역들의 UI 컴포넌트
class RegisterRegionTagCell: UICollectionViewCell {
    
    // MARK: - view UI components
    let tagLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .semibold)
        $0.textColor = .white
    }
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }
    
    // MARK: - layout constraints
    private func render() {
        self.addSubview(tagLabel)
        
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        super.layoutSubviews()
        self.backgroundColor = .regionBlue
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
    }
    
    // MARK: - check selected components
    func toggleSelected() {
        if isSelected {
            self.backgroundColor = .mainPink.withAlphaComponent(0.8)
        } else {
            self.backgroundColor = .regionBlue
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
