//
//  Message.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

//import UIKit
//
//import MessageKit
//
//struct Message: MessageType {
//    
//    let id: String?
//    var messageId: String {
//        return id ?? UUID().uuidString
//    }
//    let content: String
//    let sentDate: Date
//    let sender: SenderType
//    var kind: MessageKind {
//        if let image = image {
//            let mediaItem = ImageMediaItem(image: image)
//            return .photo(mediaItem)
//        } else {
//            return .text(content)
//        }
//    }
//    
//    var image: UIImage?
//    var downloadURL: URL?
//    
//    init(content: String) {
//        sender = Sender(senderId: "coby5502", displayName: "코비코비")
//        self.content = content
//        sentDate = Date()
//        id = nil
//    }
//    
//    init(image: UIImage) {
//        sender = Sender(senderId: "coby5502", displayName: "코비코비")
//        self.image = image
//        sentDate = Date()
//        content = ""
//        id = nil
//    }
//    
//}
//
//extension Message: Comparable {
//    static func == (lhs: Message, rhs: Message) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
//    static func < (lhs: Message, rhs: Message) -> Bool {
//        return lhs.sentDate < rhs.sentDate
//    }
//}
