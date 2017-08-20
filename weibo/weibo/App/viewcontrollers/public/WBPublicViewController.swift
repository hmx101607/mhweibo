//
//  WBPublicViewController.swift
//  weibo
//
//  Created by mason on 2017/8/20.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBPublicViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: WBChoicePictrueCollectionView!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "发微博"
        textView.delegate = self
        setupNavigationBar()
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(note:)), name: .UIKeyboardWillChangeFrame, object: nil)
    
    }
    
    @objc fileprivate func keyboardNotification(note : Notification) {
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let frame = [note.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect]
        let originY = frame.first?.origin.y
        
        toolbarBottomConstraint.constant = UIScreen.main.bounds.height - originY!
        
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func choicePictureAction(_ sender: UIButton) {
        textView.resignFirstResponder()
        
        collectionViewHeightConstraint.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
}

extension WBPublicViewController {
    
    fileprivate func setupNavigationBar (){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeAction))
        
        let rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(publicAction))
        rightBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
    }
}

extension WBPublicViewController {
    @objc fileprivate func closeAction () {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func publicAction () {
        
    }
    
    
    
}

extension WBPublicViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        tipLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
}
