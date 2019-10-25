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
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation GYLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    hx_weakify(self);
    [self.loginBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入账号"];
            return NO;
        }
        if (![strongSelf.pwd hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入密码"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf loginClicked:button];
    }];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"登录"];

    // 如果push进来的不是第一个控制器，就设置其左边的返回键
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateHighlighted];
    button.hxn_size = CGSizeMake(44, 44);
    // 让按钮内部的所有内容左对齐
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [button addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
-(void)backClicked
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerClicked:(UIButton *)sender {
    GYRegisterVC *rvc = [GYRegisterVC new];
    [self.navigationController pushViewController:rvc animated:YES];
}
- (IBAction)pwdStatusClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwd.secureTextEntry = !sender.isSelected;
}
- (void)loginClicked:(UIButton *)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = self.phone.text;
    parameters[@"password"] = self.pwd.text;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"userLogin" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] boolValue]) {
            MSUserInfo *info = [MSUserInfo yy_modelWithDictionary:responseObject[@"data"]];
            [MSUserManager sharedInstance].curUserInfo = info;
            [[MSUserManager sharedInstance] saveUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                HXTabBarController *tabvc = (HXTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                if (info.utype == 1) {
                    if (tabvc.viewControllers.count == 4) {
                        [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        HXTabBarController *tab = [[HXTabBarController alloc] init];
                        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
                        
                        //推出主界面出来
                        CATransition *ca = [CATransition animation];
                        ca.type = @"movein";
                        ca.duration = 0.5;
                        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
                    }
                }else if (info.utype == 2) {
                    if (tabvc.viewControllers.count == 3) {
                        [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        HXTabBarController *tab = [[HXTabBarController alloc] init];
                        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
                        
                        //推出主界面出来
                        CATransition *ca = [CATransition animation];
                        ca.type = @"movein";
                        ca.duration = 0.5;
                        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
                    }
                }else{
                    if (tabvc.viewControllers.count == 2) {
                        [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        HXTabBarController *tab = [[HXTabBarController alloc] init];
                        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
                        
                        //推出主界面出来
                        CATransition *ca = [CATransition animation];
                        ca.type = @"movein";
                        ca.duration = 0.5;
                        [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
                    }
                }
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [sender stopLoading:@"登录" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
    
}
- (IBAction)forgetClicked:(UIButton *)sender {
    GYChangePwdVC *pvc = [GYChangePwdVC new];
    pvc.dataType = 1;
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
