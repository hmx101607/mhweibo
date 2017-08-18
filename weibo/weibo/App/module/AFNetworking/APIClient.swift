//
//  APIClient.swift
//  weibo
//
//  Created by mason on 2017/8/12.
//  Copyright © 2017年 mason. All rights reserved.
//

import AFNetworking

// 定义枚举类型
enum RequestType : String {
    case GET = "GET"
    case POST = "POST"
}

class APIClient: AFHTTPSessionManager {
    static let shareInstance : APIClient = {
        let instance = APIClient()
        instance.responseSerializer.acceptableContentTypes?.insert("text/html")
        return instance
    }()

}

extension APIClient {
    func request(_ methodType : RequestType, urlString : String, parameters : [String : AnyObject], finished : @escaping (_ result : AnyObject?, _ error : NSError?) -> ()) {
        
        // 1.定义成功的回调闭包
        let successCallBack = { (task : URLSessionDataTask, result : AnyObject?) -> Void in
            finished(result, nil)
        }
        
        // 2.定义失败的回调闭包
        let failureCallBack = { (task : URLSessionDataTask?, error : NSError) -> Void in
            finished(nil, error)
        }
        
        // 3.发送网络请求
        if methodType == .GET {
            get(urlString, parameters: parameters, progress: nil, success: successCallBack as? (URLSessionDataTask, Any?) -> Void, failure: failureCallBack as? (URLSessionDataTask?, Error) -> Void)
        } else {
            post(urlString, parameters: parameters, progress: nil, success: successCallBack as? (URLSessionDataTask, Any?) -> Void, failure: failureCallBack as? (URLSessionDataTask?, Error) -> Void)
        }
    }
}


// MARK:- 请求AccessToken
extension APIClient {
    func loadAccessToken(code : String, finished : @escaping ((_ result : [String : AnyObject]?, _ error : NSError?)->())) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        // 2.获取请求的参数
        let parameters = ["client_id" : weibo_appkey, "client_secret" : weibo_appsecret, "grant_type" : "authorization_code", "redirect_uri" : weibo_redirect_uri, "code" : code]
        
        // 3.发送网络请求
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            MLog(message: result)
            MLog(message: error?.localizedDescription)
            finished(result as? [String : AnyObject], error)
        }

    }
}


// MARK:- 请求用户的信息
extension APIClient {
    func loadUserInfo(_ access_token : String, uid : String, finished : @escaping (_ result : [String : AnyObject]?, _ error : NSError?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : access_token, "uid" : uid]
        
        // 3.发送网络请求
        request(.GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            finished(result as? [String : AnyObject] , error)
        }
    }
}







