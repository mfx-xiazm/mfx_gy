//
//  GYOrderDetailCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYOrderDetailCell.h"
#import "GYMyOrder.h"
#import "GYMyRefund.h"

@interface GYOrderDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_title;
@property (weak, nonatomic) IBOutlet UILabel *goods_type;
@property (weak, nonatomic) IBOutlet UILabel *goods_spec;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *goods_num;
@property (weak, nonatomic) IBOutlet UILabel *total_price;
@property (weak, nonatomic) IBOutlet UILabel *order_note;
@end
@implementation GYOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(GYMyOrderGoods *)goods
{
    _goods = goods;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:_goods.goods_name withFont:[UIFont systemFontOfSize:13]];
    if ([_goods.goods_type isEqualToString:@"1"]) {
        self.goods_type.text = @" 直营商品 ";
    }else if ([_goods.goods_type isEqualToString:@"2"]) {
        self.goods_type.text = @" 库存商品 ";
    }else{
        self.goods_type.text = @" 经销商商品 ";
    }
    self.price.text = [NSString stringWithFormat:@"会员价%@",_goods.price];
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_goods.market_price]];
    self.goods_spec.text = (_goods.spec_values&&_goods.spec_values.length)?_goods.spec_values:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_goods.goods_num];
    self.total_price.text = [NSString stringWithFormat:@"￥%@",_goods.totalPrice];
    self.order_note.text = (_goods.order_note && _goods.order_note.length)?_goods.order_note:@"无备注";
}
-(void)setRefundGoods:(GYMyRefundGoods *)refundGoods
{
    _refundGoods = refundGoods;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_refundGoods.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:_refundGoods.goods_name withFont:[UIFont systemFontOfSize:13]];
    if ([_refundGoods.goods_type isEqualToString:@"1"]) {
        self.goods_type.text = @" 直营商品 ";
    }else if ([_refundGoods.goods_type isEqualToString:@"2"]) {
        self.goods_type.text = @" 库存商品 ";
    }else{
        self.goods_type.text = @" 经销商商品 ";
    }
    self.price.text = [NSString stringWithFormat:@"会员价%@",_refundGoods.price];
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_refundGoods.market_price]];
    self.goods_spec.text = (_refundGoods.spec_values&&_refundGoods.spec_values.length)?_refundGoods.spec_values:@"";
    self.goods_num.text = [NSString stringWithFormat:@"x%@",_refundGoods.goods_num];
    self.total_price.text = [NSString stringWithFormat:@"￥%@",_refundGoods.totalPrice];
    self.order_note.text = (_refundGoods.order_note && _refundGoods.order_note.length)?_refundGoods.order_note:@"无备注";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
