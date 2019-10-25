//
//  GYBannerCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYBannerCell.h"
#import "GYHomeData.h"
#import "GYGoodsDetail.h"

@implementation GYBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBanner:(GYHomeBanner *)banner
{
    _banner = banner;
    [self.bannerImg sd_setImageWithURL:[NSURL URLWithString:_banner.adv_phone_img]];
}
-(void)setBannerDict:(NSDictionary *)bannerDict
{
    _bannerDict = bannerDict;
    [self.bannerImg sd_setImageWithURL:[NSURL URLWithString:_bannerDict[@"task_img"]]];
}
-(void)setAdv:(GYGoodAdv *)adv
{
    _adv = adv;
    [self.bannerImg sd_setImageWithURL:[NSURL URLWithString:_adv.adv_img]];
}
@end
