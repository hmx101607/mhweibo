//
//  MHPhotoBrowerItemCollectionViewCell.swift
//  weibo
//
//  Created by mason on 2017/8/21.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class MHPhotoBrowerItemCollectionViewCell: UICollectionViewCell {
    
    fileprivate lazy var scrollView = UIScrollView()
    lazy var iconImageView = UIImageView()
    
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
        
        scrollView.bounds = contentView.bounds
        scrollView.frame.size.width -= 20
        
        iconImageView.frame = scrollView.bounds
        
    }
}
