//
//  WBOAuthViewController.swift
//  weibo
//
//  Created by mason on 2017/8/13.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        loadPage()
    }
}


// MARK:- 设置UI界面相关
extension WBOAuthViewController {
    fileprivate func setupNavigationBar() {
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemClick))
        
        // 2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(fillItemClick))
        
        // 3.设置标题
        title = "登录页面"
    }
    
    fileprivate func loadPage() {
        // 1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(weibo_appkey)&redirect_uri=\(weibo_redirect_uri)"
        
        // 2.创建对应NSURL
        guard let url = URL(string: urlString) else {
            return
        }
        
        // 3.创建NSURLRequest对象
        let request = URLRequest(url: url)
        
        // 4.加载request对象
        webView.delegate = self
        webView.loadRequest(request)
    }
}



// MARK:- 事件监听函数
extension WBOAuthViewController {
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fillItemClick() {
        // 1.书写js代码 : javascript / java --> 雷锋和雷峰塔
        let jsCode = "document.getElementById('userId').value='466317974@qq.com';document.getElementById('passwd').value='hmx101607';"
        
        // 2.执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}


// MARK:- webView的delegate方法
extension WBOAuthViewController : UIWebViewDelegate {
    // webView开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
//        SVProgressHUD.show()
    }
    
    // webView网页加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        SVProgressHUD.dismiss()
    }
    
    // webView加载网页失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        MLog(message: error.localizedDescription)
//        SVProgressHUD.dismiss()
    }
    
    
    // 当准备加载某一个页面时,会执行该方法
    // 返回值: true -> 继续加载该页面 false -> 不会加载该页面
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.获取加载网页的NSURL
        guard let url = request.url else {
            return true
        }
        
        // 2.获取url中的字符串
        let urlString = url.absoluteString
        
        
        // 3.判断该字符串中是否包含code
        guard urlString.contains("code=") else {
            return true
        }
        
        // 4.将code截取出来
        let code = urlString.components(separatedBy: "code=").last!
        
        // 5.请求accessToken
        loadAccessToken(code)
        
        return false
    }
    
}


// MARK:- 请求数据
extension WBOAuthViewController {
    /// 请求AccessToken
    fileprivate func loadAccessToken(_ code : String) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token?client_id=\(weibo_appkey)&client_secret=\(weibo_appsecret)&grant_type=authorization_code&redirect_uri=\(weibo_redirect_uri)&code=\(code)"
//        APIClient.shareInstance.post(urlString, parameters: nil, progress: nil, success: { (task : URLSessionDataTask, resp : AnyObject) in
//                let accout = WBAccountModel(dict: resp as! [String : AnyObject])
//                self.loadUserInfo(accout)
//            } as? (URLSessionDataTask, Any?) -> Void, failure: { (task : URLSessionDataTask?, error : NSError) in
//                MLog(message: error.domain)
//        } as? (URLSessionDataTask?, Error) -> Void)
        
        let parameters = [String : AnyObject]()
        APIClient.shareInstance.request(.POST, urlString: urlString, parameters: parameters) { (parameters :AnyObject?, error : NSError?) in
            // 1.错误校验
            if error != nil {
                print(error!)
                return
            }

            // 2.拿到结果
            guard let accountDict = parameters else {
                print("没有获取授权后的数据")
                return
            }

            // 3.将字典转成模型对象
            let account = WBAccountModel(dict: accountDict as! [String : AnyObject])
            
            // 4.请求用户信息
            self.loadUserInfo(account)
        }
        
    }
    
    
    /// 请求用户信息
    fileprivate func loadUserInfo(_ account : WBAccountModel) {
        // 1.获取AccessToken
        guard let accessToken = account.access_token else {
            return
        }
        
        // 2.获取uid
        guard let uid = account.uid else {
            return
        }
        
        // 3.发送网络请求
        APIClient.shareInstance.loadUserInfo(accessToken, uid: uid) { (result, error) -> () in
            // 1.错误校验
            if error != nil {
                print(error!)
                return
            }
            
            // 2.拿到用户信息的结果
            guard let userInfoDict = result else {
                return
            }
            
            // 3.从字典中取出昵称和用户头像地址
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            print(account)
        }
    }
}

