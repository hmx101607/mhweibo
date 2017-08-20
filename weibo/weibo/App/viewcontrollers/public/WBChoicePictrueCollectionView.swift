//
//  WBChoicePictrueCollectionView.swift
//  weibo
//
//  Created by mason on 2017/8/20.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

private let margin = 15

class WBChoicePictrueCollectionView: UICollectionView {

    var images : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dataSource = self
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - CGFloat(4 * margin)) / 3.0
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = CGFloat(margin)
        layout.minimumInteritemSpacing = CGFloat(margin)
        contentInset = UIEdgeInsetsMake(CGFloat(margin), CGFloat(margin), 0, CGFloat(margin))
        
        register(UINib.init(nibName: String(describing: WBChoicePictureItemCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: WBChoicePictureItemCollectionViewCell.self))
    }
    

}

extension WBChoicePictrueCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WBChoicePictureItemCollectionViewCell.self), for: indexPath) as! WBChoicePictureItemCollectionViewCell
        if indexPath.row == images.count {//compose_pic_add
            cell.removerBtn.isHidden = true
            cell.showBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), for: .normal)
        } else {
            cell.removerBtn.isHidden = false
            cell.showBtn.setBackgroundImage(images[indexPath.row], for: .normal)
        }
        
        return cell
    }
    
}
