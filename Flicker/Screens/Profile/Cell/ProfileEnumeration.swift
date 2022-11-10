//
//  ProfileEnumeration.swift
//  Flicker
//
//  Created by Taehwan Kim on 2022/11/04.
//
import Foundation

enum MyActivities: String, CaseIterable {
    case alertItem = "알람"
    case enrollItem = "작가등록"
    case consultItem = "문의하기"
}

enum ServiceOption: String, CaseIterable {
    case agreementItem = "이용약관"
    case companyInformationItem = "회사정보"
    case consultItem = "문의하기"
}

enum ProfileSection: Int {
    case myActivity
//    case service

    var sectionOption: [String] {
        switch self {
//        case .service:
//            return ["이용약관", "회사정보", "문의하기"]
        case .myActivity:
            return ["알람", "작가 등록", "문의하기"]
        }
    }
}
