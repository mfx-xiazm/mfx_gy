//
//  GYShopGoodsCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYShopGoodsCell.h"
#import "GYHomeData.h"

@interface GYShopGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;

@end
@implementation GYShopGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCateGood:(GYHomeCateGood *)cateGood
{
    _cateGood = cateGood;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:_cateGood.cover_img]];
    self.name.text = _cateGood.goods_name;
    self.price.text = [NSString stringWithFormat:@"会员价：%@",_cateGood.price];
    [self.marketPrice setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_cateGood.market_price]];
}
@end
