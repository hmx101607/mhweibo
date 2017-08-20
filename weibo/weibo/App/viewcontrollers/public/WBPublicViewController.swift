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
    
    
    fileprivate lazy var images : [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "发微博"
        textView.delegate = self
        setupNavigationBar()
        addNotificationCenter()
        
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
    
    fileprivate func addNotificationCenter () {
        NotificationCenter.default.addObserver(self, selector: #selector(addPicture), name: NSNotification.Name(rawValue: ADD_PICTURE_NOTIFICATION), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removePicture(note:)), name: NSNotification.Name(rawValue: ROMOVE_PICTURE_NOTIFICATION), object: nil)
    }
}

extension WBPublicViewController {
    @objc fileprivate func closeAction () {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func publicAction () {
        
    }
    
    @objc fileprivate func addPicture () {
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
        
    }
    
    @objc fileprivate func removePicture (note : Notification) {
        guard let image = note.object as? UIImage else {
            return
        }
        
        let index = images.index(of: image)
        images.remove(at: index!)
        collectionView.images = images
    }
}

extension WBPublicViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        images.append(image)
        collectionView.images = images
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension WBPublicViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        tipLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
}
