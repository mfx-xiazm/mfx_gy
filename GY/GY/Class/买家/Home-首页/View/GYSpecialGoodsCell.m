//
//  GYSpecialGoodsCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYSpecialGoodsCell.h"
#import "GYGoods.h"
#import "GYMyGoods.h"

@interface GYSpecialGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsType;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;

@end
@implementation GYSpecialGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(GYGoods *)goods
{
    _goods = goods;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_goods.cover_img]];
    self.goodsName.text = _goods.goods_name;
    self.goodsType.text = [NSString stringWithFormat:@" %@ ",_goods.goods_type_name];
    self.price.text = [NSString stringWithFormat:@"会员价%@",_goods.price];
    [self.marketPrice setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_goods.market_price]];
    if ([MSUserManager sharedInstance].isLogined) {
        if ([MSUserManager sharedInstance].curUserInfo.utype == 1) {
            self.cartBtn.hidden = NO;
        }else{
            self.cartBtn.hidden = YES;
        }
    }else{
        self.cartBtn.hidden = [_goods.goods_type isEqualToString:@"2"]?YES:NO;
    }
}
-(void)setMyGoods:(GYMyGoods *)myGoods
{
    _myGoods = myGoods;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:_myGoods.cover_img]];
    self.goodsName.text = _myGoods.goods_name;
    self.goodsType.text = [NSString stringWithFormat:@" %@ ",_myGoods.goods_type];
    self.price.text = [NSString stringWithFormat:@"会员价%@",_myGoods.price];
    [self.marketPrice setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_myGoods.market_price]];
    self.cartBtn.hidden = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
