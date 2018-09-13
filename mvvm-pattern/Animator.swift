//
//  Animator.swift
//  mvvm-pattern
//
//  Created by Watanabe Takehiro on 2018/09/13.
//  Copyright © 2018年 Watanabe Takehiro. All rights reserved.
//

import Foundation
import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting = false // 遷移してくる時はtrue
    
    /*
     実装必須
     アニメーションの時間（duration）を返します。
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    /*
     実装必須
     アニメーション内容を設定
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        
        // 具体的なアニメーション内容
        if self.presenting {
            self.presentAnimation(transitionContext: transitionContext, toView: toVC.view, fromView: fromVC.view)
        } else {
            self.dismissAnimation(transitionContext: transitionContext, toView: toVC.view, fromView: fromVC.view)
        }
        
    }
    
    // 遷移してきた時にアニメーション
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
        //
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, aboveSubview: fromView)
        // 遷移先のViewを画面の右側に移動させておく。
        toView.frame = CGRect(x: containerView.frame.width, y: 0, width: toView.frame.size.width, height: toView.frame.height)
        
        // 遷移アニメーション
        let animations = {() -> Void in
            // 遷移元のviewを少し左へずらし、alpha値を下げて少し暗くする。
            fromView.frame = CGRect(x: -70, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            fromView.alpha = 0.7
            
            // 遷移先のviewを画面全体にはまるように移動させる。
            toView.frame = containerView.frame
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: animations) {(finish) -> Void in
            // 完了後の処理
            // 元の位置に戻す
            fromView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            transitionContext.completeTransition(true)
        }
    }
    
    // 遷移元に戻るときのアニメーション
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, aboveSubview: fromView)
        
        // 遷移先のViewを画面の右側に移動させておく。
        toView.frame = CGRect(x: -containerView.frame.width, y: 0, width: toView.frame.size.width, height: toView.frame.height)
        
        let animations = {() -> Void in
            fromView.frame = CGRect(x: containerView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            toView.alpha = 1.0
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: animations) {(finish) -> Void in
            // 完了後の処理
            transitionContext.completeTransition(true)
        }
    }
}
