//
//  GYOrderDetailFooter.m
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYOrderDetailFooter.h"
#import "GYMyOrder.h"
#import "GYMyRefund.h"

@interface GYOrderDetailFooter ()
@property (weak, nonatomic) IBOutlet UILabel *order_price;
@property (weak, nonatomic) IBOutlet UILabel *order_freight;
@property (weak, nonatomic) IBOutlet UILabel *pay_amount;
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *creat_time;
@property (weak, nonatomic) IBOutlet UILabel *pay_time_tip;
@property (weak, nonatomic) IBOutlet UILabel *pay_time;
@property (weak, nonatomic) IBOutlet UILabel *pay_type_tip;
@property (weak, nonatomic) IBOutlet UILabel *pay_type;

@end

@implementation GYOrderDetailFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setOrderDetail:(GYMyOrder *)orderDetail
{
    _orderDetail = orderDetail;
    self.order_price.text = [NSString stringWithFormat:@"￥%@",_orderDetail.order_price_amount];
    self.order_freight.text = [NSString stringWithFormat:@"￥%@",_orderDetail.order_freight_amount];
    self.pay_amount.text = [NSString stringWithFormat:@"￥%@",_orderDetail.pay_amount];
    
    self.order_no.text = _orderDetail.order_no;
    self.creat_time.text = _orderDetail.create_time;
    
    if ([_orderDetail.status isEqualToString:@"已取消"] || [_orderDetail.status isEqualToString:@"待付款"]) {
        self.pay_time_tip.hidden = YES;
        self.pay_time.hidden = YES;
        self.pay_type_tip.hidden = YES;
        self.pay_type.hidden = YES;
    }else if ([_orderDetail.status isEqualToString:@"待发货"]) {
        if ([_orderDetail.pay_type isEqualToString:@"3"]) {// 线下付款
            if ([_orderDetail.approve_status isEqualToString:@"2"]) {// 审核y通过
                self.pay_time_tip.hidden = NO;
                self.pay_time.hidden = NO;
                self.pay_type_tip.hidden = NO;
                self.pay_type.hidden = NO;
                self.pay_time.text = _orderDetail.pay_time;
                
                if ([_orderDetail.pay_type isEqualToString:@"1"]) {
                    self.pay_type.text = @"支付宝";
                }else if ([_orderDetail.pay_type isEqualToString:@"2"]) {
                    self.pay_type.text = @"微信";
                }else{
                    self.pay_type.text = @"线下支付";
                }
            }else{
                self.pay_time_tip.hidden = NO;
                self.pay_time.hidden = NO;
                self.pay_type_tip.hidden = YES;
                self.pay_type.hidden = YES;
                
                self.pay_time_tip.text = @"支付方式";

                if ([_orderDetail.pay_type isEqualToString:@"1"]) {
                    self.pay_time.text = @"支付宝";
                }else if ([_orderDetail.pay_type isEqualToString:@"2"]) {
                    self.pay_time.text = @"微信";
                }else{
                    self.pay_time.text = @"线下支付";
                }
            }
        }else{
            self.pay_time_tip.hidden = NO;
            self.pay_time.hidden = NO;
            self.pay_type_tip.hidden = NO;
            self.pay_type.hidden = NO;
            self.pay_time.text = _orderDetail.pay_time;
            
            if ([_orderDetail.pay_type isEqualToString:@"1"]) {
                self.pay_type.text = @"支付宝";
            }else if ([_orderDetail.pay_type isEqualToString:@"2"]) {
                self.pay_type.text = @"微信";
            }else{
                self.pay_type.text = @"线下支付";
            }
        }
    }else{
        self.pay_time_tip.hidden = NO;
        self.pay_time.hidden = NO;
        self.pay_type_tip.hidden = NO;
        self.pay_type.hidden = NO;
        self.pay_time.text = _orderDetail.pay_time;
        
        if ([_orderDetail.pay_type isEqualToString:@"1"]) {
            self.pay_type.text = @"支付宝";
        }else if ([_orderDetail.pay_type isEqualToString:@"2"]) {
            self.pay_type.text = @"微信";
        }else{
            self.pay_type.text = @"线下支付";
        }
    }
}
-(void)setRefundDetail:(GYMyRefund *)refundDetail
{
    _refundDetail = refundDetail;
    
    self.order_price.text = [NSString stringWithFormat:@"￥%@",_refundDetail.order_price_amount];
    self.order_freight.text = [NSString stringWithFormat:@"￥%@",_refundDetail.order_freight_amount];
    self.pay_amount.text = [NSString stringWithFormat:@"￥%@",_refundDetail.pay_amount];
    
    self.order_no.text = _refundDetail.order_no;
    self.creat_time.text = _refundDetail.create_time;
    
    self.pay_time_tip.hidden = NO;
    self.pay_time.hidden = NO;
    self.pay_type_tip.hidden = NO;
    self.pay_type.hidden = NO;
    self.pay_time.text = _refundDetail.pay_time;
    
    if ([_refundDetail.pay_type isEqualToString:@"1"]) {
        self.pay_type.text = @"支付宝";
    }else if ([_refundDetail.pay_type isEqualToString:@"2"]) {
        self.pay_type.text = @"微信";
    }else{
        self.pay_type.text = @"线下支付";
    }
}
- (IBAction)orderNoCopy:(id)sender {
    if (self.refundDetail) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _refundDetail.order_no;
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _orderDetail.order_no;
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"复制成功"];
    }
}

@end
