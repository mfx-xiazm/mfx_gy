//
//  GYMyOrderFooter.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyOrderFooter.h"
#import "GYMyRefund.h"
#import "GYMyOrder.h"

@interface GYMyOrderFooter ()
@property (weak, nonatomic) IBOutlet UILabel *total_price;
@property (weak, nonatomic) IBOutlet UIButton *firstHandleBtn;
@property (weak, nonatomic) IBOutlet UIButton *secpngHandleBtn;
@end
@implementation GYMyOrderFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setRefund:(GYMyRefund *)refund
{
    _refund = refund;
    self.total_price.text = [NSString stringWithFormat:@"￥%@",_refund.pay_amount];
}
-(void)setOrder:(GYMyOrder *)order
{
    _order = order;
    self.total_price.text = [NSString stringWithFormat:@"￥%@",_order.pay_amount];
    if ([_order.approve_status isEqualToString:@"2"]) {//订单审核通过
        if ([_order.status isEqualToString:@"待付款"]) {
            self.firstHandleBtn.hidden = NO;
            [self.firstHandleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            self.firstHandleBtn.backgroundColor = [UIColor whiteColor];
            self.firstHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
            [self.firstHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            self.secpngHandleBtn.hidden = NO;
            [self.secpngHandleBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            self.secpngHandleBtn.backgroundColor = UIColorFromRGB(0xFF4D4D);
            self.secpngHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
            [self.secpngHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }else if ([_order.status isEqualToString:@"待发货"]) {
            self.firstHandleBtn.hidden = YES;
            
            self.secpngHandleBtn.hidden = NO;
            [self.secpngHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            self.secpngHandleBtn.backgroundColor = [UIColor whiteColor];
            self.secpngHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
            [self.secpngHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }else if ([_order.status isEqualToString:@"待收货"]) {
            self.firstHandleBtn.hidden = NO;
            [self.firstHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            self.firstHandleBtn.backgroundColor = [UIColor whiteColor];
            self.firstHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
            [self.firstHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            self.secpngHandleBtn.hidden = NO;
            [self.secpngHandleBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            self.secpngHandleBtn.backgroundColor = UIColorFromRGB(0xFF4D4D);
            self.secpngHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
            [self.secpngHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if ([_order.status isEqualToString:@"待评价"]) {
            self.firstHandleBtn.hidden = YES;
            
            self.secpngHandleBtn.hidden = NO;
            [self.secpngHandleBtn setTitle:@"评价" forState:UIControlStateNormal];
            self.secpngHandleBtn.backgroundColor = UIColorFromRGB(0xFF4D4D);
            self.secpngHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
            [self.secpngHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }else{
            self.firstHandleBtn.hidden = YES;
            
            self.secpngHandleBtn.hidden = YES;
        }
    }else{
        self.firstHandleBtn.hidden = YES;
        
        self.secpngHandleBtn.hidden = YES;
    }
}
- (IBAction)orderHandleClicked:(UIButton *)sender {
    if (self.orderHandleCall) {
        self.orderHandleCall(sender.tag);
    }
}

@end
