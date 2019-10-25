//
//  GYUpOrderCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYUpOrderCell.h"
#import "HXPlaceholderTextView.h"
#import "GYConfirmOrder.h"

@interface GYUpOrderCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *goods_type;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *spec_value;
@property (weak, nonatomic) IBOutlet UILabel *cart_num;
@property (weak, nonatomic) IBOutlet UILabel *freight;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@end
@implementation GYUpOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.remark.placeholder = @"备注：";
    self.remark.delegate = self;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView hasText]) {
        _goods.remark = textView.text;
    }else{
        _goods.remark = @"";
    }
}
-(void)setGoods:(GYConfirmGoodsDetail *)goods
{
    _goods = goods;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    [self.goods_name setTextWithLineSpace:5.f withString:_goods.goods_name withFont:[UIFont systemFontOfSize:13]];
    if ([_goods.goods_type isEqualToString:@"1"]) {
        self.goods_type.text = @" 直营商品 ";
    }else if ([_goods.goods_type isEqualToString:@"2"]) {
        self.goods_type.text = @" 库存商品 ";
    }else{
        self.goods_type.text = @" 经销商商品 ";
    }
    self.price.text = [NSString stringWithFormat:@"会员价%@",_goods.price];
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_goods.market_price]];
    if (_goods.spec_values && _goods.spec_values.length) {
        self.spec_value.text = [NSString stringWithFormat:@"规格：%@",_goods.spec_values];
    }else{
        self.spec_value.text = @"";
    }
    self.cart_num.text = [NSString stringWithFormat:@"数量：%@", _goods.cart_num];
    self.freight.text = [NSString stringWithFormat:@"￥%@",_goods.totalFreight];
    self.totalPrice.text = [NSString stringWithFormat:@"￥%@",_goods.totalPrice];
    
    self.remark.text = (_goods.remark && _goods.remark.length)?_goods.remark:@"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
