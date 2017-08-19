//
//  WBUserModel.swift
//  weibo
//
//  Created by mason on 2017/8/19.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBUserModel: NSObject {
    
    var profile_image_url : String? //用户头像
    var screen_name : String? //用户昵称
    var verified_type : Int = -1  //用户认证等级
    var mbrank : Int = 0 //会员等级
    
    init (dict : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
}
