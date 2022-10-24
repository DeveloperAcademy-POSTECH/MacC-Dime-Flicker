//
//  Channel.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

struct Channel {
    var id: String?
    let userImage: UIImage?
    let userName: String
    let goodImage: UIImage?
    let chatDate: String
    let chatLast: String
    
    init(id: String? = nil, userImage: UIImage? = nil, userName: String, goodImage: UIImage? = nil, chatDate: String, chatLast: String) {
        self.id = id
        self.userImage = userImage
        self.userName = userName
        self.goodImage = goodImage
        self.chatDate = chatDate
        self.chatLast = chatLast
    }
}

extension Channel: Comparable {
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.userName < rhs.userName
    }
}
