//
//  WBAccountModel.swift
//  weibo
//
//  Created by mason on 2017/8/13.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBAccountModel: NSObject {

    var access_token : String?
    var expires_in : TimeInterval = 0.0 {
        didSet {
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    var expires_date : Date?
    
    var uid : String?
    
    var screen_name : String?
    /// 用户的头像地址
    var avatar_large : String?
    
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
    // MARK:- 重写description属性
    override var description : String {
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid", "screen_name", "avatar_large"]).description
    }

}
