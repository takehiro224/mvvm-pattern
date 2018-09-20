//
//  UserCellViewModel.swift
//  mvvm-pattern
//
//  Created by 渡邊丈洋 on 2018/09/16.
//  Copyright © 2018年 Watanabe Takehiro. All rights reserved.
//

import Foundation
import UIKit

/*
 現在ダウンロード中か終了かエラーかの状態をenumで定義
 */
enum ImageDownlodProgress {
    case loading(UIImage)
    case finish(UIImage)
    case error
}

/*
 Cell一つ一つに対するアウトプットを担当
 ・ImageDownloaderからユーザーのiconをダウンロードする
 ・Imageをダウンロード中か終了かエラーかの状態を持ち、通知を送る
 ・Cellの見た目に反映させるアウトプットをする
 */
final class UserCellViewModel {
    
    /*
     ユーザーを変数として保持
     */
    private var user: User
    
    /*
     ImageDownloaderを変数として保持
     */
    private let imageDownloader = ImageDownloder()
    
    /*
     ImageDownloaderでダウンロード中かどうかのBool変数として保持
     */
    private var isLoading = false
    
    /*
     Cellに反映させるアウトプット
     */
    var nickName: String {
        return user.name
    }
    
    /*
     Cellを選択した時に必要なwebURL
     */
    var webURL: URL {
        return URL(string: user.webURL)!
    }
    
    /*
     userを引数にinit
     */
    init(user: User) {
        self.user = user
    }
    
    /*
     imageDownloaderを使ってダウンロードしてその結果をImageDownloadProgressとしてClosureで返す
     */
    func downloadImage(progress: @escaping (ImageDownlodProgress) -> Void) {
        /*
         isLoadingがtrueだったらreturnする。このメソッドはcellForRowメソッドで呼ばれることを想定しているために
         何回もダウンロードしない為にisLoadingを使用
         */
        if isLoading {
            return
        }
        isLoading = true
        
        /*
         grayのUIImageを作成
         */
        let loadingImage = UIImage(color: .gray, size: CGSize(width: 45, height: 45))!
        
        /*
         .loadingをClosureで返す
         */
        progress(.loading(loadingImage))
        
        /*
         imageDownloaderを用いて画像をダウンロード
         引数にuser.iconUrlを使用
         ダウンロードが終了したら.finishをClosureで返す
         */
        imageDownloader.downloadImage(imageURL: user.iconUrl, success: {(image) in
            progress(.finish(image))
            self.isLoading = false
        }) { (error) in
            progress(.error)
            self.isLoading = false
        }
    }
}
