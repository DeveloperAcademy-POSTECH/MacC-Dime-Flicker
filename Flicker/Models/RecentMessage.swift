//
//  RecentMessage.swift
//  CobyTalk
//
//  Created by Coby Kim on 2022/10/30.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let text, chatUserName: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
