//
//  ViewController.m
//  UIView_loading
//
//  Created by 印聪 on 2018/9/28.
//  Copyright © 2018年 印聪. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Loading.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:172/255.0 green:199/255.0 blue:240/255.0 alpha:1.0];
    button.frame = CGRectMake(self.view.bounds.size.width * 0.5 - 50, 200, 100, 50);
    [button setTitle:@"登录" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)buttonAction:(UIButton *)button{
    
    [button beginAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [button stopAnimation];
    });
    
}


@end
