//
//  RegisterWelcomView.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/01.
//

import UIKit
import SnapKit
import Then

final class RegisterWelcomView: UIView {

    private let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "작가님 어서오세요!"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .semibold)
        $0.text = "슈글을 통해 사람들의 모습을 담고,\n훌륭한 작가로 성장하세요!"
        $0.setLineSpacing(spacing: 3.0)
    }
    
    private lazy var mainImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "artistReg1.png")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    private func render() {
        self.addSubviews(mainTitleLabel, subTitleLabel, mainImage)
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(40)
            $0.leading.equalToSuperview().inset(40)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(45)
        }
        
        mainImage.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(45)
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
