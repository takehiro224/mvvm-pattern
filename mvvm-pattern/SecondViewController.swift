//
//  SecondViewController.swift
//  mvvm-pattern
//
//  Created by Watanabe Takehiro on 2018/09/13.
//  Copyright © 2018年 Watanabe Takehiro. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    let customAnimator = Animator()
    var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton = UIButton()
        self.backButton.addTarget(self, action: #selector(self.backButtonTapped(_:)), for: .touchUpInside)
        self.backButton.backgroundColor = .white
        self.view.addSubview(self.backButton)
        
        self.transitioningDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.backButton.frame = CGRect(x: 10, y: 10, width: 200, height: 100)
    }
    
    @objc func backButtonTapped(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension SecondViewController: UIViewControllerTransitioningDelegate {
    
    // この画面に遷移する時に呼ばれるメソッド(segueを使ったら起動しない)
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customAnimator.presenting = true
        return customAnimator
    }
    
    // この画面から遷移元に戻る時に呼ばれるメソッド
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customAnimator.presenting = false
        return customAnimator
    }
}
