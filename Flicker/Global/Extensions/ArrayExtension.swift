//
//  ArrayExtension.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/11/22.
//

extension Array {
    func joinString(separator: String) -> String {
        var result = ""
        for (idx, item) in self.enumerated() {
            result += "\(item)"
            if idx < self.count - 1 {
                result += separator
            }
        }
        return result
    }
}
