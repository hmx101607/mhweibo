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
         return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WBChoicePictureItemCollectionViewCell.self), for: indexPath)

        
        return cell
    }
    
}
