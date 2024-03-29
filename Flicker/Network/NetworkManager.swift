//
//  NetworkManager.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/30.
//
import UIKit
import Foundation

final class NetworkManager {

    static let shared = NetworkManager()

    private var cachedImages = NSCache<NSString, NSData>()

    func fetchOneImage(withURL url: String) async throws -> UIImage {
        var image = UIImage()
        do {
            if let cachedImage = cachedImages.object(forKey: url as NSString) {
                print("cached Image available")
                image = UIImage(data: cachedImage as Data) ?? UIImage()
            } else {
                guard let imageRequestURL = URL(string: url) else { throw NetworkError.badLocalUrl }
                async let (data, urlResponse) = URLSession.shared.data(from: imageRequestURL)
                try await self.cachedImages.setObject(data as NSData, forKey: url as NSString)
                let httpResponse = try await urlResponse as! HTTPURLResponse
                if !(200...299).contains(httpResponse.statusCode) {
                    throw NetworkError.responseError
                }
                guard let responseImage = try await UIImage(data: data) else { throw NetworkError.responseError }
                image = responseImage
            }
        } catch NetworkError.responseError {
            print(NetworkError.responseError)
        } catch NetworkError.badLocalUrl {
            print(NetworkError.badLocalUrl)
        }
        return image
    }

    func fetchImages(withURLs urls: [String]) async throws -> [UIImage] {
        var images: [UIImage] = []
        do {
            for url in urls {
                let image: UIImage = try await self.fetchOneImage(withURL: url)
                if !images.contains(image) {
                    images.append(image)
                }
            }
        } catch NetworkError.responseError {
            print(NetworkError.responseError)
        } catch NetworkError.badLocalUrl {
            print(NetworkError.badLocalUrl)
        }
        return images
    }
}
