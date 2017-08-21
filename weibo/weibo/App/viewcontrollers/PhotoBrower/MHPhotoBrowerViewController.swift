//
//  MHPhotoBrowerViewController.swift
//  weibo
//
//  Created by mason on 2017/8/21.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class MHPhotoBrowerViewController: UIViewController {
    
    fileprivate let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: MHPhotoBrowerFlowLayout())

    var indexPath : NSIndexPath?
    var picUrls : [NSURL] = [NSURL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.red
        
        setupUI()
        
    }
    
    override func loadView() {
        super.loadView()
        view.frame.size.width = UIScreen.main.bounds.size.width + 20.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }

}

extension MHPhotoBrowerViewController {
    
    fileprivate func setupUI () {
        view.addSubview(collectionView)
        let size = view.bounds.size
        collectionView.frame = CGRect(x: 0, y: 0, width: size.width - 20.0, height: size.height)
        collectionView.register(MHPhotoBrowerItemCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MHPhotoBrowerItemCollectionViewCell.self))
        collectionView.dataSource = self
        
    }
}

extension MHPhotoBrowerViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MHPhotoBrowerItemCollectionViewCell.self), for: indexPath) as! MHPhotoBrowerItemCollectionViewCell
        cell.iconImageView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.red : UIColor.blue
        return cell
    }
}

class MHPhotoBrowerFlowLayout : UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        itemSize = (collectionView?.bounds.size)!
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}













