//
//  Extension.swift
//  mvvm-pattern
//
//  Created by 渡邊丈洋 on 2018/09/17.
//  Copyright © 2018年 Watanabe Takehiro. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
