//
//  SearchViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import SnapKit
import Then

final class SearchViewController: BaseViewController {

    // MARK: - property

    private let screenText = UILabel().then {
        $0.textColor = .red
        $0.text = "검색"
    }
    
    override func render() {
        view.addSubview(screenText)
        screenText.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
