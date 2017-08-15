//
//  WBDiscoverViewController.swift
//  weibo
//
//  Created by mason on 2017/7/29.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBDiscoverViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.setupVisitorViewInfo(imageName : "visitordiscover_image_message", tipTitle: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")

    }
    

}
