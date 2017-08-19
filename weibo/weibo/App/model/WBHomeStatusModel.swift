//
//  WBHomeStatusModel.swift
//  weibo
//
//  Created by mason on 2017/8/19.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBHomeStatusModel: NSObject {
    
    var created_at : String? //微博创建时间
    var source : String?//微博来源
    var text : String?          //微博的正文
    var mid : String?           //微博的ID
    var user : WBUserModel?
    var pic_urls : [[String : String]]? //图片数组
    
    var retweeted_status : WBHomeStatusModel?//转发微博
    
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        if let userDict = dict["user"] as? [String : AnyObject] {
            user = WBUserModel(dict: userDict)
        }
        
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : AnyObject] {
            retweeted_status = WBHomeStatusModel(dict: retweetedStatusDict)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    class func loadHomeStatus (finished : @escaping (_ result : [[String : AnyObject]]?, _ error : Error?)->()) {
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parameters = ["access_token" : "2.00sMr2DDXLuxACa902dafc5dtsyVOD"]
        APIClient.shareInstance.get(url, parameters: parameters, progress: nil, success: { (task :URLSessionDataTask, resp : Any?) in
            
            guard let dict = resp as? [String : AnyObject] else {
                return
            }
            
            finished(dict["statuses"] as? [[String : AnyObject]], nil)
            
            
        }) { (task : URLSessionDataTask?,  error : Error) in
            finished(nil, error)
        }
    }

}
