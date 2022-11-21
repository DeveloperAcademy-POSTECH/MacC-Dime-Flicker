//
//  UserDefaults+Extension.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/21.
//

import Foundation

extension UserDefaults {
    func getObjects(forKeys keys: [String]) -> [String: String] {
        var results: [String: String] = [:]
        for key in keys {
            if let result = object(forKey: key) as? String {
                results[key] = result
            }
        }
        return results
    }
}
