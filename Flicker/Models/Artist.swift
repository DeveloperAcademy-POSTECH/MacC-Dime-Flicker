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
    var state: String = "서울시" // 서울로 고정
    var city: [String] // 시,군,구 -> 여기선 구
    
    var camera: String
    var lens: String
    
//    let simpleDescription: String // 한 줄 소개
    var detailDescription: String // 작가 설명
    
    var portfolioImageUrls: [String] // 포폴 사진들
}
