//
//  AppDelegate.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import Firebase
import FirebaseMessaging
import UserNotifications
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var userToken: String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let AuthController = UINavigationController(rootViewController: LogInViewController())
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
            if let error = error {
                print(error)
            }
            switch credentialState {
            case .authorized:
                print("1")
                break // 이미 로그인을 했으면 넘어가는 로직
            case .revoked, .notFound:
                print("2")
                // 로그인이 되어있지 않으면 로그인뷰로 이동
                DispatchQueue.main.async {
                    print("3")
                    self.window?.rootViewController = AuthController
                }
            default:
                break
            }
            print("4")
        }
        FirebaseApp.configure()
//
//        Messaging.messaging().delegate = self
//        UNUserNotificationCenter.current().delegate = self
//
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
//            guard success else {
//                return
//            }
//
//            print("Success in APNS registry")
//        }
//
//        application.registerForRemoteNotifications()
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            self.userToken = token
            print("Token: \(token)")
        }
    }

}
