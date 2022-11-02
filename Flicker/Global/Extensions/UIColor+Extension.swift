//
//  UIColor+Extension.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

extension UIColor {
    
    // MARK: - red

    static var mainBlack: UIColor {
        return UIColor(hex: "#182629")
    }
    
    static var textMainBlack: UIColor {
        return UIColor(hex: "#373333")
    }
    
    static var textHeadlineBlack: UIColor {
        return UIColor(hex: "#4D4444")
    }
    
    static var textSubBlack: UIColor {
        return UIColor(hex: "#6A6262")
    }
    
    static var mainYellow: UIColor {
        return UIColor(hex: "#DDC328")
    }

    static var mainPink: UIColor {
        return UIColor(hex: "E48D93")
    }

    static var loginGray: UIColor {
        return UIColor(hex: "D8D8D8")
    }

    static var textHeadLineBlack: UIColor {
        return UIColor(hex: "4D4444")
    }
    
    static var MainTintColor: UIColor {
        return UIColor(hex: "#E48D93")
    }
    
    static var FreeDealBlue: UIColor {
        return UIColor(hex: "#B4CDDB")
    }
    
    static var regionBlue: UIColor {
        return UIColor(hex: "B4CDDB")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
