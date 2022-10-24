//
//  Mocks.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import Foundation

func getChannelMocks() -> [Channel] {
    return [
        Channel(id: String(0), userName: "심규보", chatDate: "3시간 전", chatLast: "김프로 밥먹었어?"),
        Channel(id: String(1), userName: "김태환", chatDate: "9시간 전", chatLast: "놀자"),
        Channel(id: String(2), userName: "장지수", chatDate: "2일 전", chatLast: "빵"),
        Channel(id: String(2), userName: "김연호", chatDate: "3주 전", chatLast: "흐헹")
    ]
}
