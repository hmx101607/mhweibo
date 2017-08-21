//
//  WBHomeStatusTableViewCell.swift
//  weibo
//
//  Created by mason on 2017/8/19.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit
import SDWebImage

//var profile_image_url : String? //用户头像
//var screen_name : String? //用户昵称
//var verified_type : Int = -1  //用户认证等级
//var mbrank : Int = 0 //会员等级
private let margin = 15
private let itemMargin = 10

class WBHomeStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var mbrankImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var retweetedStatusLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headerImageView.layer.cornerRadius = 20.0
        headerImageView.layer.masksToBounds = true
        
        collectionView.register(UINib.init(nibName: String(describing: WBImageCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: WBImageCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    var homeStatusViewModel : WBHomeStatusViewModel? {
        didSet {
            guard let homeStatusViewModel = homeStatusViewModel else {
                return
            }
            let url = homeStatusViewModel.status?.user?.profile_image_url ?? ""
            headerImageView.setImageWith(URL(string: url)!, placeholderImage: UIImage(named: "avatar_default_small"))
            
            nameLabel.text = homeStatusViewModel.status?.user?.screen_name
            verifiedImageView.image = homeStatusViewModel.verifiedImage
            mbrankImageView.image = homeStatusViewModel.vipImage
            timeLabel.text = homeStatusViewModel.createdAtText
            sourceLabel.text = homeStatusViewModel.sourceText
            contentLabel.text = homeStatusViewModel.status?.text
            
            if let retweeted = homeStatusViewModel.status?.retweeted_status?.text, let nickName = homeStatusViewModel.status?.retweeted_status?.user?.screen_name {
                let retweetedStatus = "@\(nickName):\(retweeted)"
                retweetedStatusLabel.text = retweetedStatus
            } else {
                retweetedStatusLabel.text = nil
            }
            
            nameLabel.textColor = homeStatusViewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            let collectionSize = calculateCollectionViewSizeWithCount(count: homeStatusViewModel.picUrls.count)
            collectionViewWidthConstraint.constant = collectionSize.width
            collectionViewHeightConstraint.constant = collectionSize.height
            collectionView.reloadData()
        }
    }
    
    func calculateCollectionViewSizeWithCount(count : Int) -> CGSize {
        
        if count == 0 {
            return CGSize.zero
        }
        
//        if count == 1 {
////            let urlString = viewModel?.picURLs.last?.absoluteString
////            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlString)
//            let urlString = homeStatusViewModel?.picUrls.first?.absoluteString
//            MLog(message: "urlString:\(String(describing: urlString))")
//            let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: urlString)
//            return CGSize(width: (image?.size.width)! * 2 , height: (image?.size.height)! * 2)
//        }
        
        let width = CGFloat((UIScreen.main.bounds.width - CGFloat(2 * margin + 2 * itemMargin)) / 3)
        if count == 4 {
            let collectionViewW = 2 * width + CGFloat(itemMargin)
            return CGSize(width: collectionViewW, height: collectionViewW)
        }
        
        let rows = (count - 1) / 3 + 1
        let collectionViewH = width * CGFloat(rows) + CGFloat((rows - 1) * itemMargin)
        return CGSize(width: UIScreen.main.bounds.width - CGFloat(2 * margin), height: collectionViewH)
    }
}


extension WBHomeStatusTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return (homeStatusViewModel?.picUrls.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: String(describing: WBImageCollectionViewCell.self), for: indexPath) as! WBImageCollectionViewCell
        let url = homeStatusViewModel?.picUrls[indexPath.row]
        cell.iconImageView.setImageWith(url! as URL, placeholderImage: UIImage(named: "empty_picture"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = [BROWER_INDEX_KEY : indexPath, BROWER_PICTURE_KEY : homeStatusViewModel?.picUrls ?? [NSURL]()] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: BROWER_PICTURE_NOTIFICATION), object: self, userInfo: dict)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat((UIScreen.main.bounds.width - CGFloat(2 * margin + 2 * itemMargin)) / 3)
        return CGSize(width: width, height: width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(itemMargin)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(itemMargin)
    }
}














