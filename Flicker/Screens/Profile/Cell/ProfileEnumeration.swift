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


enum ServiceOption: String, CaseIterable {
    case agreementItem = "이용약관"
    case companyInformationItem = "회사정보"
    case consultItem = "문의하기"
}

enum ProfileSection: Int {
    case myActivity

    var sectionOption: [String] {
        switch self {
        case .myActivity:
            return ["알람", "작가 등록", "문의하기"]
        }
    }
}
