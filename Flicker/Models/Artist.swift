//
//  Artist.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/15.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit

struct Artist {
    var state: String = "전체"
    var region: [String] // 시,군,구 -> 여기선 구
    
    var camera: String
    var lens: String
    
    var detailDescription: String // 작가 설명
    
    var portfolioImageUrls: [String] // 포폴 사진들
}
