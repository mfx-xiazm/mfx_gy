//
//  GYPayTypeView.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYPayTypeView.h"
#import "GYOrderPay.h"

@interface GYPayTypeView ()
@property (weak, nonatomic) IBOutlet UILabel *pay_amount;
@property (weak, nonatomic) IBOutlet UIButton *wxPay;
@property (weak, nonatomic) IBOutlet UIButton *aliPay;
@property (weak, nonatomic) IBOutlet UIButton *outLinePay;
@property (weak, nonatomic) IBOutlet UILabel *payBankLabel;
/* 选中的那个支付方式 */
@property(nonatomic,strong) UIButton *selectPay;
@end
@implementation GYPayTypeView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.selectPay = self.wxPay;
}
- (IBAction)payTypeClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        self.payBankLabel.hidden = YES;
        self.selectPay = self.aliPay;
        [self.aliPay setImage:HXGetImage(@"付款选中") forState:UIControlStateNormal];
        [self.wxPay setImage:nil forState:UIControlStateNormal];
        [self.outLinePay setImage:nil forState:UIControlStateNormal];
    }else if (sender.tag == 2) {
        self.payBankLabel.hidden = YES;
        self.selectPay = self.wxPay;
        [self.aliPay setImage:nil forState:UIControlStateNormal];
        [self.wxPay setImage:HXGetImage(@"付款选中") forState:UIControlStateNormal];
        [self.outLinePay setImage:nil forState:UIControlStateNormal];
    }else{
        self.payBankLabel.hidden = NO;
        self.selectPay = self.outLinePay;
        [self.aliPay setImage:nil forState:UIControlStateNormal];
        [self.wxPay setImage:nil forState:UIControlStateNormal];
        [self.outLinePay setImage:HXGetImage(@"付款选中") forState:UIControlStateNormal];
    }
}
-(void)setOrderPay:(GYOrderPay *)orderPay
{
    _orderPay = orderPay;
    
    self.pay_amount.text = _orderPay.pay_amount;
    NSMutableString *payBank = [NSMutableString string];
    for (GYPayAccount *account in _orderPay.account_data) {
        if (payBank.length) {
            [payBank appendString:@"\n"];
        }
        if ([account.set_id isEqualToString:@"6"]) {
            [payBank appendFormat:@"开户银行：%@",account.set_val];
        }else if ([account.set_id isEqualToString:@"7"]) {
            [payBank appendFormat:@"银行账户：%@",account.set_val];
        }else{
            [payBank appendFormat:@"账户名称：%@",account.set_val];
        }
    }
    [self.payBankLabel setTextWithLineSpace:5.f withString:payBank withFont:[UIFont systemFontOfSize:13]];
}
- (IBAction)confirmPayClicked:(UIButton *)sender {
    if (self.confirmPayCall) {
        self.confirmPayCall(self.selectPay.tag);
    }
}

@end
