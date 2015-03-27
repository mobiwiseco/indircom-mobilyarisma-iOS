//
//  DismissingAnimationController.swift
//  IndircomMobilYarisma
//
//  Created by AhmetKeskin on 27/03/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit

class DismissingAnimationController: NSObject , UIViewControllerAnimatedTransitioning{
   
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view
        toView?.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        toView?.userInteractionEnabled = true
        
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view
        
        let closeAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
        closeAnimation.toValue = fromView?.layer.position.y
        closeAnimation.completionBlock = {(animation , finished) in
            
            transitionContext.completeTransition(true)
            
        
        }
        
        let scaleDownAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleDownAnimation.springBounciness = 20
        scaleDownAnimation.toValue = NSValue(CGPoint: CGPointMake(0, 0))
            
        
        fromView?.layer.pop_addAnimation(closeAnimation, forKey: "closeAnimation")
        fromView?.layer.pop_addAnimation(scaleDownAnimation, forKey: "scaleDown")
        
    }
    
}
