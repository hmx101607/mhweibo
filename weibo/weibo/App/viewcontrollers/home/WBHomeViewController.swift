//
//  WBHomeViewController.swift
//  weibo
//
//  Created by mason on 2017/7/29.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBHomeViewController: WBBaseViewController {

    fileprivate lazy var titleBtn : WBNavigationTitleButton  = WBNavigationTitleButton()
    fileprivate lazy var popoverAnimatedTransitioning : WBPopoverAnimatedTransitioning = WBPopoverAnimatedTransitioning { [weak self] (present) in
        self?.titleBtn.isSelected = present
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.addAnnimationView()
        
        if !isLogin {
            return
        }

        setupNavigationBar()
        
//        APIClient.shareInstance.request(.GET, urlString: "http://httpbin.org/get", parameters: ["name" : "mason" as AnyObject], finished: (AnyObject?, NSError?) -> ())
    }
    
}

extension WBHomeViewController {
    
    func setupNavigationBar () {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        navigationItem.titleView = titleBtn
        titleBtn.addTarget(self, action: #selector(titleBtnClick(titleBtn:)), for: .touchUpInside)
        
    }
    
}

extension WBHomeViewController {
    func titleBtnClick (titleBtn : WBNavigationTitleButton) {
        
        let popVC = WBPopoverViewController()
        popVC.modalPresentationStyle = .custom
        popVC.transitioningDelegate = self.popoverAnimatedTransitioning;
        
        popoverAnimatedTransitioning.presentedFrame = CGRect(x: (self.view!.frame.size.width) / 2.0 - 90, y: 54, width: 180, height: 250)


        navigationController?.present(popVC, animated: true, completion: nil)
    }
}









































