
//
//  WBVisitorView.swift
//  weibo
//
//  Created by mason on 2017/8/12.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBVisitorView: UIView {
    
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK:- 通过xib快速创建对象的方法
    class func visitorView () -> WBVisitorView {
        return Bundle.main.loadNibNamed("WBVisitorView", owner: nil, options: nil)!.first as! WBVisitorView
    }
    
    func setupVisitorViewInfo (imageName : String, tipTitle : String) {
        iconView.image = UIImage(named: imageName)
        tipLabel.text = tipTitle
        rotationView.isHidden = true
    }

    func addAnnimationView () {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = M_PI * 2
        rotationAnimation.duration = 10
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.isRemovedOnCompletion = true
        
        rotationView.layer.add(rotationAnimation, forKey: nil)
    }
}
