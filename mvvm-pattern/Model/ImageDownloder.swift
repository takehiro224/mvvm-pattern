//
//  ImageDownloder.swift
//  mvvm-pattern
//
//  Created by Watanabe Takehiro on 2018/09/14.
//  Copyright © 2018年 Watanabe Takehiro. All rights reserved.
//

import Foundation
import UIKit

final class ImageDownloder {
    
    //UIImageをキャッシュするための変数
    var cacheImage: UIImage?
    
    /*
     画像をダウンロードするリクエスト処理
     */
    func downloadImage(imageURL: String, success: @escaping (UIImage) -> Void, failure: @escaping (Error) -> Void) {
        
        /*
         もしキャッシュされたUIImageがあればキャッシュをClosureで返す
         */
        if let cacheImage = cacheImage {
            success(cacheImage)
        }
        
        /*
         リクエストを作成
         */
        guard let url = URL(string: imageURL) else {
            //
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
             受け取ったデータからUIImageを生成できなかったら、
             APIError.unknown ErrorをClosureで返す
             */
            
        }
    }
}
