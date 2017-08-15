//
//  WBPresentationController.swift
//  weibo
//
//  Created by mason on 2017/8/12.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBPresentationController: UIPresentationController {
    
    private lazy var coverView :UIView = UIView()
    var presentedFrame : CGRect = CGRect.zero
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //1.调整frame
        presentedView?.frame = presentedFrame
        
        //2.添加蒙版
        containerView!.insertSubview(coverView, belowSubview: presentedView!)
        coverView.frame = containerView!.bounds
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(dismissAction))
        coverView.addGestureRecognizer(tap)
        
    }
    
}

extension WBPresentationController {
    
    @objc fileprivate func dismissAction () {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}















