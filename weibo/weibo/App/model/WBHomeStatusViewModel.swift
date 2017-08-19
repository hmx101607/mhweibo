//
//  WBHomeStatusViewModel.swift
//  weibo
//
//  Created by mason on 2017/8/19.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBHomeStatusViewModel: NSObject {
    
    var status : WBHomeStatusModel?
    
    var sourceText : String?
    var createdAtText : String?
    
    var verifiedImage : UIImage?
    var vipImage : UIImage?
    
    init (status : WBHomeStatusModel) {
        self.status = status
        
        if let source = status.source, source != "" {
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
        if let created_at = status.created_at {
            createdAtText = NSDate.createDateString(createAtStr: created_at)
        }
        
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0 :
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5 :
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220 :
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        let  mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
    }

}
