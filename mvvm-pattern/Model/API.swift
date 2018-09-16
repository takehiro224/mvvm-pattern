//
//  API.swift
//  mvvm-pattern
//
//  Created by Watanabe Takehiro on 2018/09/14.
//  Copyright © 2018年 Watanabe Takehiro. All rights reserved.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    
    case unknown
    case invalidURL
    case invalidResponse
    
    var description: String {
        switch self {
        case .unknown: return "不明なエラーです"
        case .invalidURL: return "無効なURLです"
        case .invalidResponse: return "フォーマットが無効なレスポンスを受け取りました"
        }
    }
}

class API {
    
    func getUsers(success: @escaping ([User]) -> Void, failure: @escaping (Error) -> Void) {
        
        guard let url = URL(string: "https://api.github.com/users") else {
            failure(APIError.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            /*
             ErrorがあったらErrorをClosureで返す
             */
            if let e = error {
                DispatchQueue.main.async {
                    failure(e)
                }
                return
            }
            
            /*
             dataがなかったらError.unknownを返す
             */
            guard let d = data else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            
            /*
             レスポンスのデータ型が不正だったら
             APIError.invalidResponse ErrorをClosureで返す
             */
            guard let jsonOptional = try? JSONSerialization.jsonObject(with: d, options: []), let json = jsonOptional as? [[String: Any]] else {
                DispatchQueue.main.async {
                    failure(APIError.invalidResponse)
                }
                return
            }
            
            /*
             jsonからUserを作成し[User]に追加して[User]をClosureで返す
             */
            var users = [User]()
            for j in json {
                let user = User(attributes: j)
                users.append(user)
            }
            DispatchQueue.main.async {
                success(users)
            }
        }
        task.resume()
    }
}
