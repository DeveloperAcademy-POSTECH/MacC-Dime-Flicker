//
//  Artist.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/15.
//

import UIKit

import FirebaseFirestoreSwift

struct Artist: Codable, Identifiable {
    @DocumentID var id: String?
    var state: String = "전체"
    var regions: [String]
    
    var camera: String
    var lens: String
    
    var tags: [String]
    
    var detailDescription: String
    var portfolioImageUrls: [String]
    
    var userInfo: [String: String]
}

struct ArtistThumbnail: Identifiable {
    var id: String?
    var artistName: String
    var artistTag: String
    var artistProfileImageView: UIImage?
    var artistThumnailImageView: UIImage?
}
