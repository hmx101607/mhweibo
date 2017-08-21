//
//  MHPhotoBrowerItemCollectionViewCell.swift
//  weibo
//
//  Created by mason on 2017/8/21.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit
import SDWebImage

class MHPhotoBrowerItemCollectionViewCell: UICollectionViewCell {
    
    fileprivate lazy var scrollView = UIScrollView()
    lazy var iconImageView = UIImageView()
    
    var imagePath : URL? {
        didSet {
            guard let imagePath = imagePath else {
                return
            }
            let url = imagePath.absoluteString
            guard let image = SDWebImageManager.shared().imageCache?.imageFromMemoryCache(forKey: url) else {
                MLog(message: "没有缓存的图片:url: \(url)")
                return
            }
            iconImageView.image = image
            
            let imageViewW = UIScreen.main.bounds.width
            let imageViewH = imageViewW * (image.size.height) / (image.size.width)
            var imageViewY = CGFloat(0)
            if imageViewH > UIScreen.main.bounds.height {
                imageViewY = CGFloat(0)
            } else {
                imageViewY = CGFloat((UIScreen.main.bounds.height - imageViewH) / 2)
            }
            
            iconImageView.frame = CGRect(x: 0, y: imageViewY, width: imageViewW, height: imageViewH)
            
            iconImageView.setImageWith(URL(string: getbmiddleUrl(url: url))!)
            
            if imageViewH > UIScreen.main.bounds.height {
                scrollView.contentSize.height = imageViewH
            }
        }
    }
    
    func getbmiddleUrl(url : String) -> String {
        let urlStr = url.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return urlStr
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// setup view
extension MHPhotoBrowerItemCollectionViewCell {
    fileprivate func setupUI () {
        contentView.addSubview(scrollView)
        scrollView.addSubview(iconImageView)
        
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        
        iconImageView.frame = scrollView.bounds
        iconImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        iconImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc fileprivate func dismiss () {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: BROWER_PICTURE_DISMISS), object: nil)
    }
}
