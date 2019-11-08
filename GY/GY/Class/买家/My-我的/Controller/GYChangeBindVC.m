//
//  GYChangeBindVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYChangeBindVC.h"

@interface GYChangeBindVC ()
@property (weak, nonatomic) IBOutlet UITextField *oldPhone;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
/* 验证码id */
@property(nonatomic,copy) NSString *sms_id;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation GYChangeBindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"更换绑定手机号"];
    
    if (self.phoneStr) {
        self.oldPhone.text = self.phoneStr;
    }
    
    hx_weakify(self);
    [self.sureBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.oldPhone hasText] || strongSelf.oldPhone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"旧手机格式有误"];
            return NO;
        }
        if (![strongSelf.phone hasText] || strongSelf.phone.text.length != 11) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"新手机格式有误"];
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
        [strongSelf editPhoneRequest:button];
    }];
}
-(void)editPhoneRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.phone.text;
    parameters[@"sms_id"] = self.sms_id;
    parameters[@"sms_code"] = self.code.text;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"editPhone" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"确定修改" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"确定修改" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (IBAction)getCodeRequest:(UIButton *)sender {
    if (![self.phone hasText] || self.phone.text.length != 11) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"手机格式有误"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.phone.text;
    parameters[@"type"] = @"2";//默认为1 表示注册时获取短信验证码 为2表示修改手机号或密码或忘记密码时获取验证码
    
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

@end
