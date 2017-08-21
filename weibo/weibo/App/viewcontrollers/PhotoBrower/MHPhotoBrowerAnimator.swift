//
//  MHPhotoBrowerAnimator.swift
//  weibo
//
//  Created by mason on 2017/8/21.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

protocol PhotoBrowerAnimatorPresentedDelegate {
    //获取起始时rect
    func startRect (indexPath : NSIndexPath) -> CGRect
    //获取结束时rect
    func endRect (indexPath : NSIndexPath) -> CGRect
    //获取假的UIImageView
    func iconImageView(indexPath : NSIndexPath) -> UIImageView
}

protocol PhotoBrowerAnimatorDismissedDelegate {
    //获取indexPath
    func indexPathForDimissView() -> IndexPath
    //获取假的UIImageView
    func imageViewForDimissView() -> UIImageView
}


class MHPhotoBrowerAnimator: NSObject {
    var isPresent : Bool = false
    var indexPath : IndexPath?
    var presentDelegate : PhotoBrowerAnimatorPresentedDelegate?
    var dismissDelegate : PhotoBrowerAnimatorDismissedDelegate?

}

extension MHPhotoBrowerAnimator : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}

extension MHPhotoBrowerAnimator :  UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //动画处理
        isPresent ? presentAnimator(transitionContext: transitionContext) : dismissAnimator(transitionContext: transitionContext)
    }
}


extension MHPhotoBrowerAnimator {
    
    func presentAnimator(transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)
        let contentView = transitionContext.containerView
        contentView.addSubview(toView!)

        let startRect = presentDelegate?.startRect(indexPath: indexPath! as NSIndexPath)
        let imageView = presentDelegate?.iconImageView(indexPath: indexPath! as NSIndexPath)
        contentView.addSubview(imageView!)
        imageView?.frame = startRect!
        toView?.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView?.frame = (self.presentDelegate?.endRect(indexPath: self.indexPath! as NSIndexPath))!
        }) { (_) in
            toView?.alpha = 1
            imageView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    func dismissAnimator(transitionContext: UIViewControllerContextTransitioning) {
        
    }

}














