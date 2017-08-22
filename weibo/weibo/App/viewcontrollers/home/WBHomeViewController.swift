//
//  WBHomeViewController.swift
//  weibo
//
//  Created by mason on 2017/7/29.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class WBHomeViewController: WBBaseViewController {

    fileprivate lazy var statuss : [WBHomeStatusViewModel] = [WBHomeStatusViewModel]()
    
    fileprivate lazy var titleBtn : WBNavigationTitleButton  = WBNavigationTitleButton()
    fileprivate lazy var popoverAnimatedTransitioning : WBPopoverAnimatedTransitioning = WBPopoverAnimatedTransitioning { [weak self] (present) in
        self?.titleBtn.isSelected = present
    }
    fileprivate lazy var tipLabel : UILabel = UILabel()
    fileprivate lazy var photoBrowerAnimator : MHPhotoBrowerAnimator = MHPhotoBrowerAnimator()
    
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
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshData))
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore))
        tableView.mj_header.beginRefreshing()
        
        setupNavigationBar()
        setupTipLabel()
        addNotification()
    }
    
}

extension WBHomeViewController {
    
    func setupNavigationBar () {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
//        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        navigationItem.titleView = titleBtn
        titleBtn.addTarget(self, action: #selector(titleBtnClick(titleBtn:)), for: .touchUpInside)
        
    }
    
    fileprivate func setupTipLabel() {
        // 1.将tipLabel添加父控件中
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
        // 2.设置tipLabel的frame
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
        
        // 3.设置tipLabel的属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    
    fileprivate func addNotification () {
        NotificationCenter.default.addObserver(self, selector: #selector(browerPictureNotification(note:)), name: NSNotification.Name(rawValue: BROWER_PICTURE_NOTIFICATION), object: nil)
    }
    
    
    @objc fileprivate func browerPictureNotification (note : Notification) {
        let indexPath = note.userInfo?[BROWER_INDEX_KEY] as! NSIndexPath
        let picUrls = note.userInfo?[BROWER_PICTURE_KEY] as! [NSURL]
        let cell = note.object as! WBHomeStatusTableViewCell
        
        
        let browerPictureVC = MHPhotoBrowerViewController()
        browerPictureVC.indexPath = indexPath as IndexPath
        browerPictureVC.picUrls = picUrls
        browerPictureVC.modalPresentationStyle = .custom
        
        
        browerPictureVC.transitioningDelegate = photoBrowerAnimator
        
        photoBrowerAnimator.indexPath = indexPath as IndexPath;
        photoBrowerAnimator.presentDelegate = cell
        photoBrowerAnimator.dismissDelegate = browerPictureVC
        
        present(browerPictureVC, animated: true, completion: nil)
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
    fileprivate func loadStatus(isNewData : Bool) {
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = statuss.first?.status?.mid ?? 0
        } else {
            max_id = statuss.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        
        WBHomeStatusModel.loadHomeStatus(since_id: since_id, max_id: max_id) { (result, error) in
            if error != nil {
                
                return
            }
            
            guard let statusArray = result else {
                
                return
            }
            
            var tempViewModel = [WBHomeStatusViewModel]()
            for dic in statusArray {
                let homeStatusModel = WBHomeStatusModel(dict: dic)
                let homeStatusViewModel = WBHomeStatusViewModel(status: homeStatusModel)
                tempViewModel.append(homeStatusViewModel)
            }
            
            if isNewData {
                self.statuss = tempViewModel + self.statuss
            } else {
                self.statuss += tempViewModel
            }
            
            self.cacheImage(homeStatusArray: tempViewModel)
        }
    }
    
    fileprivate func cacheImage(homeStatusArray : [WBHomeStatusViewModel]) {
        let group = DispatchGroup()
        for homeStatusViewModel in homeStatusArray {
            for url in homeStatusViewModel.picUrls {
                group.enter()
                
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: [], progress: nil, completed: { (_, _, _, _) in
                    MLog(message: "url: \(url)")
                    group.leave()
                })
                
            }
        }
        
        group.notify(queue: DispatchQueue.main) { 
            self.tableView.reloadData()
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.showTipLabel(count: homeStatusArray.count)
        }
    }
    
    /// 显示提示的Label
    fileprivate func showTipLabel(count : Int) {
        // 1.设置tipLabel的属性
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count) 条新微博"
        
        // 2.执行动画
        UIView.animate(withDuration: 1.0, animations: { 
            self.tipLabel.frame.origin.y = 44
        }) { (_) in
            UIView.animateKeyframes(withDuration: 1.0, delay: 1.5, options: [], animations: { 
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
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

extension WBHomeViewController {
    @objc func refreshData () {
        loadStatus(isNewData: true)
    }
    
    @objc func loadMore () {
        loadStatus(isNewData: false)
    }
    
    
}






































