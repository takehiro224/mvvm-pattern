//
//  TimeLineViewController.swift
//  mvvm-pattern
//
//  Created by 渡邊丈洋 on 2018/09/22.
//  Copyright © 2018年 Watanabe Takehiro. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class TimeLineViewController: UIViewController {
    
    fileprivate var viewModel: UserListViewModel!
    fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewを生成
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeLineCell.self, forCellReuseIdentifier: "TimeLineCell")
        view.addSubview(tableView)
        
        // UIRefreshControllを生成し、リフレッシュした時に呼ばれるメソッドを定義しtableViewにセット
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChanged(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // UserListViewModelを生成し、通知を受け取った時の処理を定義
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = {[weak self] state in
            switch state {
            case .loading:
                // 通信中はtableViewを操作不可に
                self?.tableView.isUserInteractionEnabled = false
            case .finish:
                // 通信が完了したらtableViewを操作可能にし、tableViewを更新
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            case .error(let error):
                // ErrorだったらtableViewを操作可能に
                self?.tableView.isUserInteractionEnabled = true
                self?.refreshControl.endRefreshing()
                let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        // ユーザー一覧を取得
        viewModel.getUsers()
    }
    
    @objc func refreshControlValueDidChanged(sender: UIRefreshControl) {
        // リフレッシュした時ユーザー一覧を取得している
        viewModel.getUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: - UITableViewDataSource
extension TimeLineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let timelineCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as? TimeLineCell {
            /*
             CellのUserCellViewModelを取得してtimelineCellに対してnicknameとiconをセット
             */
            let cellViewModel = viewModel.cellViewModels[indexPath.row]
            timelineCell.setNickName(nickName: cellViewModel.nickName)
            
            cellViewModel.downloadImage{ (progress) in
                switch progress {
                case .loading(let image):
                    timelineCell.setIcon(icon: image)
                case .finish(let image):
                    timelineCell.setIcon(icon: image)
                case .error:
                    break
                }
            }
            return timelineCell
        }
        fatalError()
    }
}


// MARK: - UITableViewDelegate
extension TimeLineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         cellのUserCellViewModelを取得し、そのユーザーのGithubページへ画面遷移している
         */
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let webURL = cellViewModel.webURL
        let webViewController = SFSafariViewController(url: webURL)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
}
