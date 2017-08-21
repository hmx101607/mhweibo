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
        addNotification()
        
    }
    
    override func loadView() {
        super.loadView()
        view.frame.size.width = UIScreen.main.bounds.size.width + 20.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension MHPhotoBrowerViewController {
    
    fileprivate func setupUI () {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.register(MHPhotoBrowerItemCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MHPhotoBrowerItemCollectionViewCell.self))
        collectionView.dataSource = self
    }
    
    fileprivate func addNotification () {
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPhotoBrower), name: NSNotification.Name(rawValue: BROWER_PICTURE_DISMISS), object: nil)
    }
    
    @objc func dismissPhotoBrower () {
        dismiss(animated: true, completion: nil)
    }
}

extension MHPhotoBrowerViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MHPhotoBrowerItemCollectionViewCell.self), for: indexPath) as! MHPhotoBrowerItemCollectionViewCell
        cell.imagePath = picUrls[indexPath.row] as URL
        return cell
    }
}

class MHPhotoBrowerFlowLayout : UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        itemSize = (collectionView?.frame.size)!
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}













