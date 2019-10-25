//
//  GYInvoiceVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYInvoiceVC.h"
#import "GYConfirmOrder.h"

@interface GYInvoiceVC ()
@property (weak, nonatomic) IBOutlet UITextField *et_name;
@property (weak, nonatomic) IBOutlet UITextField *organ_code;
@property (weak, nonatomic) IBOutlet UITextField *register_address;
@property (weak, nonatomic) IBOutlet UITextField *contact_phone;
@property (weak, nonatomic) IBOutlet UITextField *open_bank;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *receiver;
@property (weak, nonatomic) IBOutlet UITextField *receive_phone;
@property (weak, nonatomic) IBOutlet UITextField *receive_address;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation GYInvoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"开具发票"];
    
    if (self.userInvoice) {
        self.et_name.text = self.userInvoice.et_name;
        self.organ_code.text = self.userInvoice.organ_code;
        self.register_address.text = self.userInvoice.register_address;
        self.contact_phone.text = self.userInvoice.contact_phone;
        self.open_bank.text = self.userInvoice.open_bank;
        self.account.text = self.userInvoice.account;
        self.receiver.text = self.userInvoice.receiver;
        self.receive_phone.text = self.userInvoice.receive_phone;
        self.receive_address.text = self.userInvoice.receive_address;
    }
    
    hx_weakify(self);
    [self.submitBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.et_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写企业名称"];
            return NO;
        }
        if (![strongSelf.organ_code hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写企业社会统一信用代码"];
            return NO;
        }
        if (![strongSelf.register_address hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写企业注册地址"];
            return NO;
        }
        if (![strongSelf.contact_phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写企业电话"];
            return NO;
        }
        if (![strongSelf.open_bank hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写开户行"];
            return NO;
        }
        if (![strongSelf.account hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写账号"];
            return NO;
        }
        if (![strongSelf.receiver hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写收票人姓名"];
            return NO;
        }
        if (![strongSelf.receive_phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写收票人电话"];
            return NO;
        }
        if (![strongSelf.receive_address hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写送票地址"];
            return NO;
        }
        
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf saveUserInvoiceRequest:button];
    }];
}

-(void)saveUserInvoiceRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"et_name"] = self.et_name.text;//开票企业名称
    parameters[@"organ_code"] = self.organ_code.text;//社会统一信用代码
    parameters[@"register_address"] = self.register_address.text;//注册地址
    parameters[@"contact_phone"] = self.contact_phone.text;//开户行
    parameters[@"open_bank"] = self.open_bank.text;//开票企业名称
    parameters[@"account"] = self.account.text;//账户
    parameters[@"receiver"] = self.receiver.text;//收票人
    parameters[@"receive_phone"] = self.receive_phone.text;//收票人联系电话
    parameters[@"receive_address"] = self.receive_address.text;//送票地址
    if (self.userInvoice) {
        parameters[@"user_invoice_id"] = self.userInvoice.user_invoice_id;//发票id
    }

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"saveUserInvoice" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.saveInvoiceCall) {
                strongSelf.saveInvoiceCall();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
