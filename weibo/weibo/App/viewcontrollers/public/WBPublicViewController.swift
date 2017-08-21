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
    
    fileprivate lazy var emoticonVc : EmoticonController = EmoticonController { (emoticon) in
        self.insertEmoticonIntoTextView(emoticon: emoticon)
    }
    
    fileprivate func insertEmoticonIntoTextView(emoticon : Emoticon) {
        if emoticon.isEmpty {
            
            return
        }
        
        if emoticon.isRemove {
            textView.deleteBackward()
            return
        }
        
        if emoticon.emojiCode != nil {
            let textRange = textView.selectedTextRange
            textView.replace(textRange!, withText: emoticon.emojiCode!)
            return
        }
        
        let attachemnt = WBEmojiTextAttachment()
        attachemnt.chs = emoticon.chs
        attachemnt.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = textView.font
        attachemnt.bounds = CGRect(x: 0, y: -4, width: font!.lineHeight, height: font!.lineHeight)
        let imageTextAttributed = NSAttributedString(attachment: attachemnt)
        
        let originTextAttributed = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let seletedRange = textView.selectedRange
        
        originTextAttributed.replaceCharacters(in: seletedRange, with: imageTextAttributed)
        
        textView.attributedText = originTextAttributed
        
        textView.font = font
        
        textView.selectedRange = NSRange(location: seletedRange.location + 1, length: 0)
    }
    
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
    
    @IBAction func emojiAction(_ sender: UIButton) {
        textView.resignFirstResponder()
        
        textView.inputView = emoticonVc.view
        textView.becomeFirstResponder()
        
    }
    
    @IBAction func showKeyboardAction(_ sender: UIButton) {
        textView.resignFirstResponder()
        
        textView.inputView = nil
        textView.becomeFirstResponder()
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
        
        let resultAttributed = NSMutableAttributedString(attributedString: textView.attributedText)
        let ranges = NSRange(location: 0, length: resultAttributed.length)
        resultAttributed.enumerateAttributes(in: ranges, options: []) { (dict, range, _) in
            if let textAttachment = dict["NSAttachment"] as? WBEmojiTextAttachment {
                resultAttributed.replaceCharacters(in: range, with: textAttachment.chs!)
            }
        }
        
        
        MLog(message: resultAttributed.string)
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
