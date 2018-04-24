//
//  CTPushTransition.m
//  ChildTrack
//
//  Created by zhangzey on 23/04/2018.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "CTPushTransition.h"

@implementation CTPushTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.8f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = CGRectOffset(finalFrameForVC, 0, -ScreenH);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        fromVC.view.alpha = 0.8;
        toVC.view.frame = finalFrameForVC;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        fromVC.view.alpha = 1.0;
    }];
}

@end
