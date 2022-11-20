//
//  AppleLoginManager.swift
//  Flicker
//
//  Created by 김연호 on 2022/11/17.
//

import UIKit

import AuthenticationServices
import CryptoKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

final class LoginManager: NSObject {
    static let shared = LoginManager()

    var currentNonce: String?
    var currentAppleIdToken: String?

    
    @available(iOS 13, *)
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        // 애플로그인은 사용자에게서 2가지 정보를 요구함
        request.requestedScopes = [.fullName, .email]

        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce

        return request
    }

    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }

   func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
    //애플 재인증 함수
    func appleLoginReAuthUser() async {
        // Initialize a fresh Apple credential with Firebase.
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: self.currentAppleIdToken ?? "" ,
            rawNonce: self.currentNonce
        )
        // Reauthenticate current Apple user with fresh Apple credential.
        Auth.auth().currentUser?.reauthenticate(with: credential) { (authResult, error) in
            guard error != nil else { return }
        }
    }
    //회원탈퇴 함수
    func fireBasewithDraw() async {
        let user = Auth.auth().currentUser

        user?.delete { error in
            if let error = error {
                //회원탈퇴 실패
                print(error)
            }
        }
    }
    //로그아웃 함수
    func fireBaseSignOut() async {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()

        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
