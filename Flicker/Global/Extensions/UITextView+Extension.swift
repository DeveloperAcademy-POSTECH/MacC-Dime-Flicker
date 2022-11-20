//
//  UITextView+Extension.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

extension UITextView {
    func setLineAndLetterSpacing(_ text: String, color: UIColor){
        let style = NSMutableParagraphStyle()
        // 행간 세팅
        style.lineSpacing = 5
        let attributedString = NSMutableAttributedString(string: text)
        // 자간 세팅
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 0, length: text.count) )
        self.attributedText = attributedString
    }
}
