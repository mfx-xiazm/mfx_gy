//
//  GYMyOrderCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyOrderCell.h"
#import "GYMyRefund.h"
#import "GYMyOrder.h"

@interface GYMyOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_title;
@property (weak, nonatomic) IBOutlet UILabel *goods_type;
@property (weak, nonatomic) IBOutlet UILabel *goods_spec;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *goods_num;

@end
@implementation GYMyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setRefund:(GYMyRefund *)refund
{
    _refund = refund;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_refund.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:_refund.goods_name withFont:[UIFont systemFontOfSize:13]];
    if ([_refund.goods_type isEqualToString:@"1"]) {
        self.goods_type.text = @" 直营商品 ";
    }else if ([_refund.goods_type isEqualToString:@"2"]) {
        self.goods_type.text = @" 积压甩卖 ";
    }else{
        self.goods_type.text = @" 经销商商品 ";
    }
    self.price.text = [NSString stringWithFormat:@"会员价%@",_refund.price];
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_refund.market_price]];
    self.goods_spec.text = (_refund.spec_values&&_refund.spec_values.length)?[NSString stringWithFormat:@"规格：%@",_refund.spec_values]:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_refund.goods_num];
}
-(void)setGoods:(GYMyOrderGoods *)goods
{
    _goods = goods;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:_goods.goods_name withFont:[UIFont systemFontOfSize:13]];
    if ([_goods.goods_type isEqualToString:@"1"]) {
        self.goods_type.text = @" 直营商品 ";
    }else if ([_goods.goods_type isEqualToString:@"2"]) {
        self.goods_type.text = @" 积压甩卖 ";
    }else{
        self.goods_type.text = @" 经销商商品 ";
    }
    self.price.text = [NSString stringWithFormat:@"会员价%@",_goods.price];
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_goods.market_price]];
    self.goods_spec.text = (_goods.spec_values&&_goods.spec_values.length)?[NSString stringWithFormat:@"规格：%@",_goods.spec_values]:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_goods.goods_num];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
