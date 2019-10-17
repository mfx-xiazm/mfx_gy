//
//  GYRegisterSuccessVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYRegisterSuccessVC.h"
#import "HXTabBarController.h"

@interface GYRegisterSuccessVC ()

@end

@implementation GYRegisterSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"提交成功"];
}
- (IBAction)goHomeVC:(UIButton *)sender {
    
    HXTabBarController *tab = [[HXTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    
    //推出主界面出来
    CATransition *ca = [CATransition animation];
    ca.type = @"movein";
    ca.duration = 0.5;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
}

@end
