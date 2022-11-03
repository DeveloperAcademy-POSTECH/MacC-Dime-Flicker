//
//  MainViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import SnapKit
import Then

final class MainViewController: BaseViewController {
    
    private var region: String = "전체"

    // MARK: - property
    
    private let appTitleLabel = UILabel().then {
        $0.font = UIFont(name: "TsukimiRounded-Bold", size: 30)
        $0.textColor = .mainPink
        $0.textAlignment = .center
        $0.text = "SHUGGLE"
    }
    
    private let regionListHorizontalView = RegionListHorizontalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regionListHorizontalView.setParentViewController(viewController: self)
    }
    
    override func render() {
        view.addSubviews(appTitleLabel, regionListHorizontalView)
        
        appTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(20)
        }
        
        regionListHorizontalView.snp.makeConstraints {
            $0.top.equalTo(appTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    func setRegion(region: String) {
        self.region = region
    }
}
