//
//  GYInvoiceDetailFooter.m
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYInvoiceDetailFooter.h"
#import "GYMyOrder.h"
#import "GYMyRefund.h"

@interface GYInvoiceDetailFooter ()
@property (weak, nonatomic) IBOutlet UILabel *organ_msg;
@property (weak, nonatomic) IBOutlet UILabel *receive_msg;
@end
@implementation GYInvoiceDetailFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setOrderDetail:(GYMyOrder *)orderDetail
{
    _orderDetail = orderDetail;
    [self.organ_msg setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",_orderDetail.et_name,_orderDetail.organ_code,_orderDetail.register_address,_orderDetail.contact_phone,_orderDetail.open_bank,_orderDetail.account] withFont:[UIFont systemFontOfSize:12]];
    
    [self.receive_msg setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"%@\n%@\n%@",_orderDetail.invoice_receive,_orderDetail.receive_phone,_orderDetail.receive_address] withFont:[UIFont systemFontOfSize:12]];
}
-(void)setRefundDetail:(GYMyRefund *)refundDetail
{
    _refundDetail = refundDetail;
    [self.organ_msg setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",_refundDetail.et_name,_refundDetail.organ_code,_refundDetail.register_address,_refundDetail.contact_phone,_refundDetail.open_bank,_refundDetail.account] withFont:[UIFont systemFontOfSize:12]];
    
    [self.receive_msg setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"%@\n%@\n%@",_refundDetail.invoice_receive,_refundDetail.receive_phone,_refundDetail.receive_address] withFont:[UIFont systemFontOfSize:12]];
}
@end
