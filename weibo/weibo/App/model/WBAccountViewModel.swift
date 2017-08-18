//
//  WBAccountViewModel.swift
//  weibo
//
//  Created by mason on 2017/8/18.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBAccountViewModel: NSObject {
    static let shareIntance : WBAccountViewModel =  WBAccountViewModel ()

    var account : WBAccountModel?

    var accountPath : String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).appendingPathComponent("accout.plist")
    }
    
    var isLogin : Bool {
        if account == nil {
            return false
        }
        guard let expiresDate = account?.expires_date  else {
            return false
        }
        
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    // MARK:- 重写init()函数
    override init () {
        super.init()
        // 1.从沙盒中读取中归档的信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: self.accountPath) as? WBAccountModel
//        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? WBAccountModel
    }
}
