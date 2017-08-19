//
//  WBWelcomeViewController.swift
//  weibo
//
//  Created by mason on 2017/8/18.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit
import SDWebImage

class WBWelcomeViewController: UIViewController {

    @IBOutlet weak var headerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerImageView.layer.cornerRadius = headerImageView.frame.size.width / 2.0
        headerImageView.layer.masksToBounds = true
        
        let urlStr = WBAccountViewModel.shareIntance.account?.avatar_large
        let url = NSURL(string: urlStr ?? "")
        headerImageView.setImageWith(url! as URL)
    
        headerBottomConstraint.constant = UIScreen.main.bounds.size.height - 200.0
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            
            UIApplication.shared.keyWindow?.rootViewController = WBTabbarViewController()
            
        }
    }

 

}
