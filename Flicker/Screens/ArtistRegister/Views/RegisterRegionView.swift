//
//  RegisterRegionView.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/01.
//

import UIKit
import SnapKit
import Then

class RegisterRegionView: UIView {
    
    private let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "지역 설정"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .semibold)
        $0.text = "주로 활동하는 지역을 알려주세요!"
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium)
        $0.text = "지역은 최대 3개까지 설정할 수 있어요."
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    private func render() {
        self.addSubviews(mainTitleLabel, subTitleLabel, bodyTitleLabel)
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(40)
            $0.leading.equalToSuperview().inset(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
