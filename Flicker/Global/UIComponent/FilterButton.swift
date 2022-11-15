//
//  FilterButton.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/15.
//

import UIKit

final class FilterButton: UIButton {

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 44, height: 44)))
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func configUI() {
        self.setImage(ImageLiteral.btnFilter, for: .normal)
        self.tintColor = .mainBlack
    }
}
