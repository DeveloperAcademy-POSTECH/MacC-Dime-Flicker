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
        $0.contentHorizontalAlignment = .leading
        $0.tintColor = .systemFill
        $0.setImage(image, for: .normal)
        $0.sizeToFit()
    }
    
    let popImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(named: "gliderWithoutBG")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageTapped()
        self.backgroundColor = .systemBackground
    }
    
    // MARK: - layout constraints
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }

    private func render() {
        self.addSubviews(customBackButton, popImage)
        
        customBackButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.width.equalTo(100)
            $0.height.equalToSuperview()
        }
        
        popImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
            $0.size.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RegisterCustomNavigationView {
    private func imageTapped() {
        let imageTapped = UITapGestureRecognizer(target: self, action: #selector(imageAnimate))
        self.addGestureRecognizer(imageTapped)
    }
    
    @objc func imageAnimate() {
        let newImageSize: CGFloat = 30
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: ({
            self.popImage.frame = CGRect(x: 0, y: 0, width: newImageSize, height: newImageSize)}), completion: nil)
    }
}
