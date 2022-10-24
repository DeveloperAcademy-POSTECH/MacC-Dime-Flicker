//
//  FirebaseManager.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import Firebase
import FirebaseAuth
import FirebaseFirestore

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    static let store = Firestore.firestore()
    static let auth = Auth.auth()
    
    private init() { }
    
    func signInUser(email: String, password: String) async -> String? {
        do {
            let data = try await FirebaseManager.auth.signIn(withEmail: email, password: password)
            print("Success LogIn")
            return data.user.uid
        } catch {
            print("Failed to LogIn")
            return nil
        }
    }
    
    func createNewAccount(email: String, password: String) async {
        do {
            try await FirebaseManager.auth.createUser(withEmail: email, password: password)
            print("Successfully created user")
        } catch {
            print("Failed to create user")
        }
    }
    
    func deleteAccount() async {
        do {
            try await FirebaseManager.auth.currentUser?.delete()
        } catch {
            print("Failed to disconnect friend")
        }
    }
    
    func storeUserInformation(email: String, name: String) async {
        guard let uid = FirebaseManager.auth.currentUser?.uid else { return }
        do {
            let appDelegate = await UIApplication.shared.delegate as! AppDelegate
            let userToken = await appDelegate.userToken
            let userData = ["email": email, "uid": uid, "name": name, "token": userToken]
        
            try await FirebaseManager.store.collection("users").document(uid).setData(userData)
        } catch {
            print("Store User error")
        }
    }
    
    func updateUserToken(uid: String) async {
        do {
            let appDelegate = await UIApplication.shared.delegate as! AppDelegate
            let userToken = await appDelegate.userToken
            try await FirebaseManager.store.collection("users").document(uid).updateData(["token" : userToken])
            print("Success Update")
        } catch {
            print("Update User error")
        }
    }
}
