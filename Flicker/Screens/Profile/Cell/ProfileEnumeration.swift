//
//  ProfileEnumeration.swift
//  Flicker
//
//  Created by Taehwan Kim on 2022/11/04.
//
import Foundation

enum SettingsNoArtists: String, CaseIterable {
    case alertItem = "알림"
    case enrollItem = "작가등록"
    case consultItem = "문의하기"
}

enum SettingsArtists: String, CaseIterable {
    case alertItem = "알림"
    case portfolioItem = "작가설정"
    case consultItem = "문의하기"
}

enum Logout: String, CaseIterable {
    case logoutItem = "로그아웃"
}

enum SignOut: String, CaseIterable {
    case signOutItem = "탈퇴하기"
}

enum ProfileSection: Int {
    case SettingsNoArtists
    case SettingArtists
    case Logout
    case SignOut
    
    var sectionOption: [String] {
        switch self {
        case .SettingsNoArtists:
            return ["알람", "작가등록", "문의하기"]
        case .SettingArtists:
            return ["알람", "작가설정", "문의하기"]
        case .Logout:
            return ["로그아웃"]
        case .SignOut:
            return ["탈퇴하기"]
        }
    }
}

//struct SettingCell {
//    let name: String
//    let handler: () -> ()
//}
//
//let cell = SettingCell(name: "알람") {
//    print("안녕")
//}
//
//let cells = [cell, cell, cell, cell, cell, cell, cell]

// MARK: - 현재 안 사용되고 있는 enum
//enum ServiceOption: String, CaseIterable {
//    case agreementItem = "이용약관"
//    case companyInformationItem = "회사정보"
//    case consultItem = "문의하기"
//}
