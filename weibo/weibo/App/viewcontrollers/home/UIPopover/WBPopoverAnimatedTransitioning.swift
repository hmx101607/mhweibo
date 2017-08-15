//
//  WBPopoverAnimatedTransitioning.swift
//  weibo
//
//  Created by mason on 2017/8/12.
//  Copyright © 2017年 mason. All rights reserved.
//

import UIKit

class WBPopoverAnimatedTransitioning: NSObject {
    fileprivate var isPresent : Bool = false
    var callBlock : ((_ present : Bool) -> ())?
    var presentedFrame : CGRect = CGRect.zero

    init(callBlock : @escaping (_ present : Bool) -> ()) {
        self.callBlock = callBlock
    }

}


extension WBPopoverAnimatedTransitioning : UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentVC = WBPresentationController(presentedViewController: presented, presenting: presenting)
        presentVC.presentedFrame = presentedFrame
        return presentVC
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        callBlock!(isPresent)
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        callBlock!(isPresent)
        return self
    }
    
}

extension WBPopoverAnimatedTransitioning : UIViewControllerAnimatedTransitioning {
    
    //设定转场时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    //自定义转场动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            //present
            //1.获取弹出的view
            let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            //2.将弹出的view加入到容器中
            transitionContext.containerView.addSubview(presentView!)
            //3.设定view的动画
            presentView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            presentView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0);
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                presentView?.transform = CGAffineTransform.identity
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        } else {
            //dismiss
            //1.获取dismiss的View
            let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            //2.消失动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0000001)
            }, completion: { (_) in
                dismissView?.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
}

