//
//  NSObject+Extension.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
