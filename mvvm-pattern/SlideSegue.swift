//
//  SlideSegue.swift
//  mvvm-pattern
//
//  Created by Watanabe Takehiro on 2018/09/13.
//  Copyright © 2018年 Watanabe Takehiro. All rights reserved.
//

import Foundation
import UIKit

class SlideSegue: UIStoryboardSegue {
    
    private static var animating: Bool = false
    
    override func perform() {
        if !SlideSegue.animating {
            let src = self.source
            let dst = self.destination
            
            src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
            dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
            
            SlideSegue.animating = true
            UIView.animate(
                withDuration: 0.25,
                delay: 0.0,
                options: UIView.AnimationOptions.curveEaseInOut,
                animations: {
                    dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
            },
                completion: { _ in
                    src.present(dst, animated: false, completion: nil)
                    SlideSegue.animating = false
            }
            )
        }
    }
}
