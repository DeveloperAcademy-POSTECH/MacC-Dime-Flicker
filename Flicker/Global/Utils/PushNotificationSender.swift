//
//  PushNotificationSender.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import Foundation

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        let server_key = "AAAAvWyUGFU:APA91bHKwd0IyOHA4v86X-NuBKcOTmpt-N1nOppmN94jMbj_Rcl9UrpwGgjlnZAL4gAI-cI2sQI2CtRyX_Qo5zxgZPdueJlM7KQc5ExshtOOtqKrDHaJOVZjL5u2jfSnOk4Aazna1_n3"
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(server_key)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
