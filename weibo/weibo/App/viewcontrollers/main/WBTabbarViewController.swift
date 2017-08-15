//
//  WBTabbarViewController.swift
//  weibo
//
//  Created by mason on 2017/7/29.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBTabbarViewController: UITabBarController {

    private lazy var publicBtn = UIButton(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加控制器页面
        addChildViewController(childVCName: "WBHomeViewController", title: "首页", imageName: "tabbar_home")
        addChildViewController(childVCName: "WBMessageViewController", title: "消息", imageName: "tabbar_profile")
        addChildViewController(childVCName: "WBNullViewController", title: "", imageName: "")
        addChildViewController(childVCName: "WBDiscoverViewController", title: "发现", imageName: "tabbar_discover")
        addChildViewController(childVCName: "WBMeViewController", title: "我的", imageName: "tabbar_profile")
        
        //添加中间位置tabbarItem
        tabBar.addSubview(publicBtn)
        publicBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
        publicBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: .highlighted)
        publicBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
        publicBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        publicBtn.sizeToFit()
        publicBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.frame.size.height * 0.5)
        publicBtn.addTarget(self, action: #selector(buttonTap(button:)), for: .touchUpInside)
        
        //1.读取json文件
        /*
        guard let jsonPath = Bundle.main.path(forResource: "MainVCSettings", ofType: "json") else {
            MLog(message: "json文件不存在")
            return
        }
        //2.从文件中读取数据
        guard let data = NSData(contentsOfFile: jsonPath) else {
            MLog(message: "json文件中午数据")
            return
        }
        //3.解析json文件中的数据
        guard let anyObject = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) else {
            MLog(message: "解析失败")
            return
        }
        guard let dicArray = anyObject as? [[String : AnyObject]] else {
            return
        }
        for dic in dicArray {
            guard let chileVCName = dic["vcName"] as? String else {
                continue
            }
            guard let title = dic["title"] as? String else {
                continue
            }
            guard let imageName = dic["imageName"] as? String else {
                continue
            }
            addChildViewController(childVCName: chileVCName, title: title, imageName: imageName)
        }*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let count = tabBar.items?.count else {
            MLog(message: "items为空")
            return
        }
        
        for i in 0..<count{
            let item = tabBar.items![i]
            // 3.如果是下标值为2,则该item不可以和用户交互
            if i == 2 {
                item.isEnabled = false
                break
            }
        }

    }
    
    private func addChildViewController(childVCName: String, title : String, imageName : String) {
        
        // 1. 获取命名空间
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            MLog(message: "命名空间不存在")
            return
        }
        //2. 根据命名空间和类名确定类是否存在
        guard let childVCClass = NSClassFromString(nameSpace + "." + childVCName) else {
            MLog(message: "该类不存在")
            return
        }
        
        //3. 获取具体的类的类型
        guard let childType = childVCClass as? UIViewController.Type else {
            MLog(message: "类型不存在")
            return;
        }
        let childVC = childType.init()
        childVC.title = title
        childVC.tabBarItem.image = UIImage(named: imageName)
        childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        let nav = UINavigationController(rootViewController: childVC)
        addChildViewController(nav)
    }
    
    func buttonTap(button : UIButton) {
        
    }


}
