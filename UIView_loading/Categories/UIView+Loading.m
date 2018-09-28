//
//  UIView+Loading.m
//  AnimationDemo
//
//  Created by 印聪 on 2018/9/28.
//  Copyright © 2018年 印聪. All rights reserved.
//

#import "UIView+Loading.h"
#import <objc/runtime.h>


static NSString *kAnimationViewKey = @"AnimationView";

static NSString *kAnimationDurationKey = @"AnimationDuration";

@interface UIView()

@property (nonatomic , strong)UIView *animationView;

@property (nonatomic , assign)CGFloat duration;

@end

@implementation UIView (Loading)

- (void)setDuration:(CGFloat)duration{
    objc_setAssociatedObject(self, &kAnimationDurationKey, @(duration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)duration{
    NSNumber *num = objc_getAssociatedObject(self, &kAnimationDurationKey);
    if (num == nil || [num floatValue] == 0) {
        return 0.6; //默认为0.6
    }
    return [num floatValue];
}

- (UIView *)animationView{
    return objc_getAssociatedObject(self, &kAnimationViewKey);
}

- (void)setAnimationView:(UIView *)animationView{
    objc_setAssociatedObject(self, &kAnimationViewKey, animationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (void)beginAnimation{
    self.hidden = YES;
    UIView *animationView = [[UIView alloc] initWithFrame:self.frame];
    animationView.backgroundColor = self.backgroundColor;
    animationView.layer.masksToBounds = self.layer.masksToBounds;
    animationView.layer.cornerRadius = self.layer.cornerRadius;
    [self.superview insertSubview:animationView belowSubview:self];
    
    [UIView animateWithDuration:self.duration animations:^{
        animationView.bounds = CGRectMake(0, 0, animationView.bounds.size.height, animationView.bounds.size.height);
        animationView.layer.cornerRadius = animationView.bounds.size.width * 0.5;
    } completion:^(BOOL finished) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(animationView.bounds.size.height * 0.5, animationView.bounds.size.height * 0.5) radius:(animationView.bounds.size.height * 0.5 - 5) startAngle:0 endAngle:-M_PI_2 clockwise:NO];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 2.0;
        [animationView.layer addSublayer:shapeLayer];
        
        //让圆转圈，实现"加载中"的效果
        CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        baseAnimation.duration = 0.8;
        baseAnimation.fromValue = @(0);
        baseAnimation.toValue = @(2 * M_PI);
        baseAnimation.repeatCount = MAXFLOAT;
        [animationView.layer addAnimation:baseAnimation forKey:nil];
        
    }];
    
    self.animationView = animationView;
    
}

- (void)stopAnimation{
    UIView *animationView = self.animationView;
    if (animationView) {
        for (CAShapeLayer *layer in animationView.layer.sublayers) {
            [layer removeFromSuperlayer];
        }
        [animationView.layer removeAllAnimations];
        [UIView animateWithDuration:self.duration animations:^{
            animationView.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            animationView.layer.cornerRadius = self.layer.cornerRadius;
        } completion:^(BOOL finished) {
            self.hidden = NO;
            [animationView removeFromSuperview];
        }];
    }

}

@end
