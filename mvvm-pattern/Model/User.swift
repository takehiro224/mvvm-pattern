//
//  User.swift
//  mvvm-pattern
//
//  Created by Watanabe Takehiro on 2018/09/14.
//  Copyright © 2018年 Watanabe Takehiro. All rights reserved.
//

import Foundation

final class User {
    let id: Int
    let name: String
    let iconUrl: String
    let webURL: String
    
    init(attributes: [String: Any]) {
        id = attributes[" id"] as! Int
        name = attributes[" login"] as! String
        iconUrl = attributes[" avatar_ url"] as! String
        webURL = attributes[" html_ url"] as! String
    }
}
