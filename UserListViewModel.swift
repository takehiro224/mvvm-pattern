//
//  UserListViewModel.swift
//  mvvm-pattern
//
//  Created by 渡邊丈洋 on 2018/09/16.
//  Copyright © 2018年 Watanabe Takehiro. All rights reserved.
//

import Foundation
import UIKit

/*
 現在通信中か通信が成功したのか失敗したのかの状態をenumで定義
 */
enum ViewModelState {
    case loading
    case finish
    case error(Error)
}

/*
 ・APIクラスからuserの配列を受け取る
 ・userの配列分だけUserCellViewModelを作成して保持する
 ・通信の状態を持ち、その状態をVCに伝える。その状態によっていtableViewを更新すべきかをVCが決定する
 ・tableViewを表示する為に必要なアウトプットを出力する
 */
final class UserListViewModel {
    
    /*
     ViewModelStateをClosureとしてpropertyで保持
     この変数がViewControllerに対して通知を送る役割を果たす
     */
    var stateDidUpdate: ((ViewModelState) -> Void)?
    
    /*
     userの配列
     */
    private var users = [User]()
    
    /*
     UserCellViewModelの配列
     */
    var cellViewModels = [UserCellViewModel]()
    
    /*
     Model層で定義したAPIクラスを変数として保持
     */
    let api = API()
    
    /*
     User配列を取得する
     */
    func getUsers() {
        /*
         .loading通知を送る
         */
        stateDidUpdate?(.loading)
        users.removeAll()
        api.getUsers(success: {(users) in
            self.users.append(contentsOf: users)
            for user in users {
                /*
                 UserCellViewModelの配列を作成
                 */
                let cellViewModel = UserCellViewModel(user: user)
                self.cellViewModels.append(cellViewModel)
                
                /*
                 通信が成功したので.finish通知を送る
                 */
                self.stateDidUpdate?(.finish)
            }
        }) { (error) in
            /*
             通信が失敗したので.error通知を送る
             */
            self.stateDidUpdate?(.error(error))
        }
    }
    
    /*
     tableViewを表示させる為に必要なアウトプット
     UserLisetViewModelはtableView全体に対するアプトプットなのでtableViewのcountに必要なusers.coutがアウトプット
     tableViewCellに対するアウトプットはUserCellViewModelが担当
     */
    func userCount() -> Int {
        return users.count
    }
}
