//
//  UIViewController+Extension.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case present
        case presentNavigation
        case presentFullNavigation
        case push
    }
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
            
        case .presentNavigation:
            let nav = UINavigationController(rootViewController: viewController)
            self.present(nav, animated: true)
            
        case .presentFullNavigation:
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = .overFullScreen
            self.present(nav, animated: true)
            
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    func changeRootView<T: UIViewController>(_ viewController: T) {
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
           let sceneDelegate = windowScene?.delegate as? SceneDelegate
           
           let viewCon = viewController
           
           sceneDelegate?.window?.rootViewController = UINavigationController(rootViewController: viewCon)
           sceneDelegate?.window?.makeKeyAndVisible()
       }

    func makeAlert(title: String,
                   message: String,
                   okAction: ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    func makeRequestAlert(title: String,
                          message: String,
                          okTitle: String = "확인",
                          cancelTitle: String = "취소",
                          okAction: ((UIAlertAction) -> Void)?,
                          cancelAction: ((UIAlertAction) -> Void)? = nil,
                          completion : (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancelAction)
        alertViewController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: okTitle, style: .destructive, handler: okAction)
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    func makeActionSheet(title: String? = nil,
                         message: String? = nil,
                         actionTitles:[String?],
                         actionStyle:[UIAlertAction.Style],
                         actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: actionStyle[index], handler: actions[index])
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func hidekeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
