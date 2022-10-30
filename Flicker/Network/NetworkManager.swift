//
//  NetworkManager.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/30.
//

import Foundation

class NetworkManager {

    static var shared = NetworkManager()

    private var cachedImages = NSCache<NSString, NSData>()

    let session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }

    private func makeURLComponents() -> URLComponents {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.unsplash.com"
        component.path = "/search/photos"
        return component
    }

    private func makeURLRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(AccessKey.accessKey)", forHTTPHeaderField: "Authorization")
        return request
    }

    // TODO: DTO에 따라 파라미터 변경 가능
    func loadImageCheckingCached(post: Post, completion: @escaping (Data?, Error?) -> (Void)) {
        let url = URL(string: post.urls.regular)!
        loadImage(imageURL: url, completion: completion)
    }

    private func loadImage(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        if let imageData = cachedImages.object(forKey: imageURL.absoluteString as NSString) {
            print("using cached images")
            completion(imageData as Data, nil)
            return
        }

        let task = session.downloadTask(with: imageURL) { localUrl, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }

            guard let localUrl = localUrl else {
                completion(nil, NetworkManagerError.badLocalUrl)
                return
            }

            do {
                let data = try Data(contentsOf: localUrl)
                self.cachedImages.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }

        task.resume()
    }

    func queryDB(query: String, completion: @escaping ([Post]?, Error?) -> (Void)) {
        var URLComponent = makeURLComponents()
        URLComponent.queryItems = [ URLQueryItem(name: "query", value: query) ]
        let request = makeURLRequest(url: URLComponent.url!)

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            // optional binding
            guard let httpResonse = response as? HTTPURLResponse, (200...299).contains(httpResonse.statusCode) else {
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }

            guard let data = data else {
                completion(nil, NetworkManagerError.badData)
                return
            }

            // response handling
            do {
                let response = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(response.results, nil)
            } catch let error {
                completion(nil, error)
            }
        }

        // asynch task resume
        task.resume()
    }
}
