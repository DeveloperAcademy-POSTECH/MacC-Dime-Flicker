//
//  User.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, name, token: String
}
