//
//  GYCartCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYCartCell.h"
#import "GYCartData.h"

@interface GYCartCell ()
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *goods_type;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *spec_value;
@property (weak, nonatomic) IBOutlet UILabel *cart_num;

@end
@implementation GYCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCart:(GYCartData *)cart
{
    _cart = cart;
    self.checkBtn.selected = _cart.is_checked;
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_cart.cover_img]];
    [self.goods_name setTextWithLineSpace:5.f withString:_cart.goods_name withFont:[UIFont systemFontOfSize:13]];
    if ([_cart.goods_type isEqualToString:@"1"]) {
        self.goods_type.text = @" 直营商品 ";
    }else if ([_cart.goods_type isEqualToString:@"2"]) {
        self.goods_type.text = @" 库存商品 ";
    }else{
        self.goods_type.text = @" 经销商商品 ";
    }
    self.price.text = [NSString stringWithFormat:@"会员价%@",_cart.price];
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_cart.market_price]];
    if (_cart.spec_values && _cart.spec_values.length) {
        self.spec_value.text = [NSString stringWithFormat:@"规格：%@",_cart.spec_values];
    }else{
        self.spec_value.text = @"";
    }
    self.cart_num.text = _cart.cart_num;
}
- (IBAction)numChangeClicked:(UIButton *)sender {
    if (sender.tag) {// +
        if ([self.cart_num.text integerValue] + 1 > [_cart.stock_num integerValue]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"库存不足"];
            return;
        }
        self.cart_num.text = [NSString stringWithFormat:@"%zd",[self.cart_num.text integerValue] + 1];
    }else{// -
        if ([self.cart_num.text integerValue] - 1 < 1) {
            return;
        }
        self.cart_num.text = [NSString stringWithFormat:@"%zd",[self.cart_num.text integerValue] - 1];
    }
    _cart.cart_num = self.cart_num.text;
    if (self.cartHandleCall) {
        self.cartHandleCall(sender.tag);
    }
}
- (IBAction)checkClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    _cart.is_checked = sender.isSelected;
    if (self.cartHandleCall) {
        self.cartHandleCall(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
