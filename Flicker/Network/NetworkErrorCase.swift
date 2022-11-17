//
//  NetworkErrorCase.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/30.
//

import Foundation

enum NetworkError: Error {
    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
    case responseError
}
