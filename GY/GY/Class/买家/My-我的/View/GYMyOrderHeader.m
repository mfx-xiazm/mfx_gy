//
//  GYMyOrderHeader.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyOrderHeader.h"
#import "GYMyRefund.h"
#import "GYMyOrder.h"

@interface GYMyOrderHeader ()
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *order_state;
@end
@implementation GYMyOrderHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setRefund:(GYMyRefund *)refund
{
    _refund = refund;
    self.order_no.text = [NSString stringWithFormat:@"订单编号：%@",_refund.order_no];
    /* 1等待经销商审核 2等待平台审核 3退款成功 4退款驳回 5经销商同意 6经销商不同意*/
    if ([_refund.refund_status isEqualToString:@"1"]) {
        self.order_state.text = @"等待经销商审核";
    }else if ([_refund.refund_status isEqualToString:@"2"]){
        self.order_state.text = @"等待平台审核";
    }else if ([_refund.refund_status isEqualToString:@"3"]){
        self.order_state.text = @"退款成功";
    }else if ([_refund.refund_status isEqualToString:@"4"]){
        self.order_state.text = @"退款驳回";
    }else if ([_refund.refund_status isEqualToString:@"5"]){
        self.order_state.text = @"经销商同意";
    }else{
        self.order_state.text = @"经销商不同意";
    }
}
-(void)setOrder:(GYMyOrder *)order
{
    _order = order;
    self.order_no.text = [NSString stringWithFormat:@"订单编号：%@",_order.order_no];
    self.order_state.text = _order.status;
}
@end
