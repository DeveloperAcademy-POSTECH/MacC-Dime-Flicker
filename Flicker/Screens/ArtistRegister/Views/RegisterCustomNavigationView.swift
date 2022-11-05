//
//  RegisterCustomNavigationView.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/03.
//

import UIKit
import SnapKit
import Then

    // MARK: - custom Navigation bar view
class RegisterCustomNavigationView: UIView {
    
    // MARK: - back button UI components
    lazy var customBackButton = UIButton(type: .system).then {
        let config = UIImage.SymbolConfiguration(textStyle: .title1, scale: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        $0.tintColor = .systemFill
        $0.setImage(image, for: .normal)
        $0.sizeToFit()
    }
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
    }
    
    // MARK: - layout constraints
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }

    private func render() {
        self.addSubview(customBackButton)
        
        customBackButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.size.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
