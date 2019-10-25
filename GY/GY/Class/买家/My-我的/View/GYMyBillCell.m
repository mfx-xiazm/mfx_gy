//
//  GYMyBillCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyBillCell.h"
#import "GYMyBill.h"

@interface GYMyBillCell ()
@property (weak, nonatomic) IBOutlet UIView *order_view;
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *order_title;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *order_amount;
@property (weak, nonatomic) IBOutlet UILabel *pay_type;

@property (weak, nonatomic) IBOutlet UIView *other_view;
@property (weak, nonatomic) IBOutlet UILabel *other_title;
@property (weak, nonatomic) IBOutlet UILabel *other_create_time;
@property (weak, nonatomic) IBOutlet UILabel *other_amount;

@end
@implementation GYMyBillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBill:(GYMyBill *)bill
{
    _bill = bill;
    if ([_bill.finance_log_type isEqualToString:@"1"] || [_bill.finance_log_type isEqualToString:@"10"]) {
        self.order_view.hidden = NO;
        self.other_view.hidden = YES;
        self.order_no.text = [NSString stringWithFormat:@"订单编号：%@",_bill.info.order_no];
        self.order_title.text = _bill.finance_log_desc;
        self.order_amount.text = [NSString stringWithFormat:@"%@元",_bill.amount];
        self.create_time.text = _bill.create_time;
        self.pay_type.text = _bill.info.pay_type;
    }else{
        self.order_view.hidden = NO;
        self.other_view.hidden = YES;
        self.order_no.text = [NSString stringWithFormat:@"订单编号：%@",_bill.info.member_order_no];
        self.order_title.text = _bill.finance_log_desc;
        self.order_amount.text = [NSString stringWithFormat:@"%@元",_bill.amount];
        self.create_time.text = _bill.create_time;
        self.pay_type.text = _bill.info.pay_type;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
