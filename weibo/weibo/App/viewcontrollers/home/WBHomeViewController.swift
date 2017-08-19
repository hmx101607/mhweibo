//
//  WBHomeViewController.swift
//  weibo
//
//  Created by mason on 2017/7/29.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit
import SDWebImage

class WBHomeViewController: WBBaseViewController {

    fileprivate lazy var statuss : [WBHomeStatusViewModel] = [WBHomeStatusViewModel]()
    
    fileprivate lazy var titleBtn : WBNavigationTitleButton  = WBNavigationTitleButton()
    fileprivate lazy var popoverAnimatedTransitioning : WBPopoverAnimatedTransitioning = WBPopoverAnimatedTransitioning { [weak self] (present) in
        self?.titleBtn.isSelected = present
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.addAnnimationView()
        
        
        if !isLogin {
            return
        }
        
        let accessToken = WBAccountViewModel.shareIntance.account?.access_token
        MLog(message: "access_token:\(accessToken!)")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200.0
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: String(describing: WBHomeStatusTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: WBHomeStatusTableViewCell.self))
        setupNavigationBar()
        loadStatus()
    }
    
}

extension WBHomeViewController {
    
    func setupNavigationBar () {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        navigationItem.titleView = titleBtn
        titleBtn.addTarget(self, action: #selector(titleBtnClick(titleBtn:)), for: .touchUpInside)
        
    }
    
}

extension WBHomeViewController {
    func titleBtnClick (titleBtn : WBNavigationTitleButton) {
        
        let popVC = WBPopoverViewController()
        popVC.modalPresentationStyle = .custom
        popVC.transitioningDelegate = self.popoverAnimatedTransitioning;
        
        popoverAnimatedTransitioning.presentedFrame = CGRect(x: (self.view!.frame.size.width) / 2.0 - 90, y: 54, width: 180, height: 250)


        navigationController?.present(popVC, animated: true, completion: nil)
    }
}


extension WBHomeViewController {
    fileprivate func loadStatus() {
        WBHomeStatusModel.loadHomeStatus { (result, error) in
            if error != nil {
                
                return
            }
            
            guard let statusArray = result else {
                
                return
            }
            
            for dic in statusArray {
                let homeStatusModel = WBHomeStatusModel(dict: dic)
                let homeStatusViewModel = WBHomeStatusViewModel(status: homeStatusModel)
                self.statuss.append(homeStatusViewModel)
            }
            self.cacheImage(homeStatusArray: self.statuss)
        }
    }
    
    fileprivate func cacheImage(homeStatusArray : [WBHomeStatusViewModel]) {
        let group = DispatchGroup()
        for homeStatusViewModel in homeStatusArray {
            for url in homeStatusViewModel.picUrls {
                group.enter()
                
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: url as URL, options: [], progress: nil, completed: { (_, _, _, _) in
                    group.leave()
                    MLog(message: "下载了一张图片")
                })
            }
        }
        
        group.notify(queue: DispatchQueue.main) { 
            self.tableView.reloadData()
            MLog(message: "刷新表格")
        }
    }
}

extension WBHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuss.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WBHomeStatusTableViewCell.self))! as! WBHomeStatusTableViewCell
        let homeStatusViewModel = statuss[indexPath.row]
        cell.homeStatusViewModel = homeStatusViewModel
        return cell
    }
}






































