//
//  WBChoicePictureItemCollectionViewCell.swift
//  weibo
//
//  Created by mason on 2017/8/20.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBChoicePictureItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet weak var removerBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func removeAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ROMOVE_PICTURE_NOTIFICATION), object: showBtn.currentBackgroundImage)
    }
    
    @IBAction func addImageAction(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ADD_PICTURE_NOTIFICATION), object: nil)

    }
}
