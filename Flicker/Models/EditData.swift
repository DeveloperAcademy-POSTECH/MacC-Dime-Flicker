//
//  EditData.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/29.
//

import UIKit

// MARK: - New Data set for Editing Views
struct EditData: Equatable {
    var regions: [String]
    var camera: String
    var lens: String
    var tags: [String]
    var detailDescription: String
    var portfolioImages: [UIImage]
    var portfolioUrls: [String]
}
