//
//  Static.swift
//  Flicker
//
//  Created by 김연호 on 2022/11/29.
//

import UIKit

final class DeviceFrame {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static var exceptPaddingWidth: CGFloat {
        return screenWidth - 40
    }
}
