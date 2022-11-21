//
//  User.swift
//  CobyTalk
//
//  Created by Coby Kim on 2022/10/30.
//

import FirebaseFirestoreSwift
import UIKit

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, name, profileImageUrl, token: String
}

final class CurrentUserDataManager {

    static let shared = CurrentUserDataManager()

    private let defaults = UserDefaults.standard

    func saveUserDefault() async {
        if let userData = await FirebaseManager.shared.getUser() {
            defaults.set(userData.email, forKey: "userEmail")
            defaults.set(userData.name, forKey: "userName")
            defaults.set(userData.profileImageUrl, forKey: "userProfileImageUrl")
            defaults.set(userData.token, forKey: "userToken")
        }
    }
}
