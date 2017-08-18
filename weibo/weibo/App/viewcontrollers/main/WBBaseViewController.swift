//
//  WBBaseViewController.swift
//  weibo
//
//  Created by mason on 2017/8/12.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {
     // MARK:- 懒加载属性
    lazy var visitorView : WBVisitorView = WBVisitorView.visitorView()
    // MARK:- 是否登录
    var isLogin : Bool = WBAccountViewModel.shareIntance.isLogin
    
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}

extension WBBaseViewController {
    fileprivate func setupVisitorView () {
        view = visitorView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(loginBtnClick))
        
        visitorView.registerButton.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        visitorView.loginButton.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        
    }
    
}

extension WBBaseViewController {
    @objc fileprivate func registerBtnClick () {
        MLog(message: "注册")
    }
    
    @objc fileprivate func loginBtnClick () {
        // 1.创建授权控制器
        let oauthVc = WBOAuthViewController()
        
        // 2.包装导航栏控制器
        let oauthNav = UINavigationController(rootViewController: oauthVc)
        
        // 3.弹出控制器
        present(oauthNav, animated: true, completion: nil)
        
    }
}




