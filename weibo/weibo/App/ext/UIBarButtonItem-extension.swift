//
//  UIBarButtonItem-extension.swift
//  weibo
//
//  Created by mason on 2017/8/12.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(imageName : String) {
        self.init()
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        customView = btn
    }
}
