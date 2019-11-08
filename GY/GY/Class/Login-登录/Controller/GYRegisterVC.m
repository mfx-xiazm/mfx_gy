//
//  GYRegisterVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYRegisterVC.h"
#import "GYRegisterAuthVC.h"

@interface GYRegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *code;
/* 验证码id */
@property(nonatomic,copy) NSString *sms_id;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation GYRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"注册"];
    hx_weakify(self);
    [self.nextBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.phone hasText] || strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机格式有误"];
            return NO;
        }
        if (![strongSelf.pwd hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入密码"];
            return NO;
        }
        if (!strongSelf.sms_id || !strongSelf.sms_id.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请获取验证码"];
            return NO;
        }
        if (![strongSelf.code hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入验证码"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf nextBtnClicked:button];
    }];
}
- (IBAction)pwdStatusClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwd.secureTextEntry = !sender.isSelected;
}
- (IBAction)getCodeRequest:(UIButton *)sender {
    if (![self.phone hasText] || self.phone.text.length != 11) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机格式有误"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.phone.text;
    parameters[@"type"] = @"1";//默认为1 表示注册时获取短信验证码 为2表示修改手机号或密码或忘记密码时获取验证码
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getCheckCode" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [sender startWithTime:60 title:@"获取验证码" countDownTitle:@"s" mainColor:HXControlBg countColor:HXControlBg];
            strongSelf.sms_id = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

- (void)nextBtnClicked:(UIButton *)sender {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"sms_id"] = self.sms_id;//短信验证码id
    parameters[@"sms_code"] = self.code.text;//短信验证码
    parameters[@"phone"] = self.phone.text;//手机号

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"checkCode" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"下一步" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                GYRegisterAuthVC *avc = [GYRegisterAuthVC new];
                avc.phone = strongSelf.phone.text;
                avc.pwd = strongSelf.pwd.text;
                [strongSelf.navigationController pushViewController:avc animated:YES];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [sender stopLoading:@"下一步" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}


@end
