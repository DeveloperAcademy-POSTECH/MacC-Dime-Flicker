//
//  NavigationBarItem.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/11/28.
//

import UIKit

final class ReportButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 44, height: 44)))
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func

    private func configUI() {
        self.setImage(ImageLiteral.reportButton, for: .normal)
        self.tintColor = .mainBlack
    }
}

