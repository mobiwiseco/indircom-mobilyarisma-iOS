//
//  PresentingAnimationController.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 26/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit

class PresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        
        return 0.5;
        
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view
        fromView?.tintAdjustmentMode = UIViewTintAdjustmentMode.Dimmed
        fromView?.userInteractionEnabled = false
        
        let toView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view
        toView?.frame = CGRectMake(0, 0, CGRectGetWidth(transitionContext.containerView().bounds), CGRectGetHeight(transitionContext.containerView().bounds))
        let p : CGPoint = CGPointMake(transitionContext.containerView().center.x, -transitionContext.containerView().center.y)
        
        transitionContext.containerView().addSubview(toView!)
        
        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        positionAnimation.toValue = transitionContext.containerView().center.y
        positionAnimation.springBounciness = 10
        positionAnimation.completionBlock = {(animation, finished) in
            
            transitionContext.completeTransition(true)
            
            println("pop animation finished")
        }
        
        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation.springBounciness = 20
        scaleAnimation.fromValue = NSValue(CGPoint: CGPointMake(1.2, 1.4))
        
        toView?.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
        toView?.layer .pop_addAnimation(scaleAnimation, forKey: "scaleAnimation")
       
        
        
    }
   
}
