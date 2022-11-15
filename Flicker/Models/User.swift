//
//  User.swift
//  CobyTalk
//
//  Created by Coby Kim on 2022/10/30.
//

import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, name, profileImageUrl, token: String
}
