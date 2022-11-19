//
//  ProfileEnumeration.swift
//  Flicker
//
//  Created by Taehwan Kim on 2022/11/04.
//
import Foundation

enum Logout: String, CaseIterable {
    case logoutItem = "로그아웃"
}

enum SignOut: String, CaseIterable {
    case signOutItem = "탈퇴하기"
}

enum AppStrings {
    static let regiseterArtist = "작가등록"
    static let settingArtist = "작가설정"
}

enum ProfileSection: Int, CaseIterable {
    case settings
    case logout
    case signOut
    
    func sectionOptions(isArtist: Bool) -> [String] {
        let category = isArtist ? "작가설정" : "작가등록"
        
        switch self {
        case .settings:
            return ["알람", category, "문의하기"]
        case .logout:
            return ["로그아웃"]
        case .signOut:
            return ["탈퇴하기"]
        }
    }
}
