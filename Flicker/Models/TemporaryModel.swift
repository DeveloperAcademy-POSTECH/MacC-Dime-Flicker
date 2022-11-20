//
//  TemporaryModel.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/11/20.
//

import UIKit

struct TestUser: Codable {
    let camera, detailDescription, lens : String?
    let portfolioImageUrls: [String]?
    let regions: [String]?
    let state: String?
}
