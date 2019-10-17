//
//  GYLoginVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYLoginVC.h"
#import "GYChangePwdVC.h"
#import "GYRegisterVC.h"
#import "HXTabBarController.h"

@interface GYLoginVC ()

@end

@implementation GYLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"登录"];
}
- (IBAction)registerClicked:(UIButton *)sender {
    GYRegisterVC *rvc = [GYRegisterVC new];
    [self.navigationController pushViewController:rvc animated:YES];
}
- (IBAction)loginClicked:(UIButton *)sender {
    HXTabBarController *tab = [[HXTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    
    //推出主界面出来
    CATransition *ca = [CATransition animation];
    ca.type = @"movein";
    ca.duration = 0.5;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
}
- (IBAction)forgetClicked:(UIButton *)sender {
    GYChangePwdVC *pvc = [GYChangePwdVC new];
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
