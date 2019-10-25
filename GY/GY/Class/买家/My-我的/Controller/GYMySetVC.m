//
//  GYMySetVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMySetVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GYChangePwdVC.h"
#import "GYChangeBindVC.h"
#import "GYChangeInfoVC.h"
#import "HXTabBarController.h"

@interface GYMySetVC ()

@end

@implementation GYMySetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置"];
}
- (IBAction)setBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        GYChangeInfoVC *ivc = [GYChangeInfoVC new];
        ivc.mineData = self.mineData;
        [self.navigationController pushViewController:ivc animated:YES];
    }else if (sender.tag == 2) {
        GYChangeBindVC *bvc = [GYChangeBindVC new];
        [self.navigationController pushViewController:bvc animated:YES];
    }else if (sender.tag == 3) {
        GYChangePwdVC *pvc = [GYChangePwdVC new];
        pvc.dataType = 2;
        [self.navigationController pushViewController:pvc animated:YES];
    }else{
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录？" constantWidth:HX_SCREEN_WIDTH - 50*2];
        hx_weakify(self);
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"退出" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
            
            [[MSUserManager sharedInstance] logout:nil];//清空登录数据
            
            HXTabBarController *tab = [[HXTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tab;
            
            //推出主界面出来
            CATransition *ca = [CATransition animation];
            ca.type = @"movein";
            ca.duration = 0.5;
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }
}

@end
