//
//  UILabel+Extension.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

extension UILabel {
    @available(iOS 13.0, *)
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
    
    @available(iOS 14.0, *)
    func addLabelSpacing(kernValue: Double = 0.0, lineSpacing: CGFloat = 6.0) {
        if let labelText = self.text, labelText.count > 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributedText = NSAttributedString(string: labelText,
                                                attributes: [.kern: kernValue,
                                                             .paragraphStyle: paragraphStyle])
            lineBreakStrategy = .hangulWordPriority
        }
    }
    
    func setTyping(text: String, characterDelay: TimeInterval = 5.0) {
        self.text = ""
        
        let writingTask = DispatchWorkItem { [weak self] in
            text.forEach { char in
                DispatchQueue.main.async {
                    self?.text?.append(char)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }
        
        let queue: DispatchQueue = .init(label: "typespeed", qos: .userInteractive)
        queue.asyncAfter(deadline: .now() + 0.7, execute: writingTask)
    }
    
    

    func makeBasicLabelEx(labelText: String, textColor: UIColor ,fontStyle: UIFont.TextStyle, fontWeight: UIFont.Weight) -> UILabel {
        let label = UILabel().then {
            $0.text = labelText
            $0.textColor = textColor
            $0.font = .preferredFont(forTextStyle: fontStyle, weight: fontWeight)
        }
        return label
    }
}
