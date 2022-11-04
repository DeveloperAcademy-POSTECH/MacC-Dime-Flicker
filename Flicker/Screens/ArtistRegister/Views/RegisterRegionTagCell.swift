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
        // 여기선 어떻게 동적으로 바꿔야할지 몰라서 일단 상수로 cornerRadiius 를 줬습니다.
        self.layer.cornerRadius = 8
    }
    
    // MARK: - check selected components
    func toggleSelected() {
        if isSelected {
            self.backgroundColor = .systemPink
        } else {
            self.backgroundColor = .regionBlue
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
