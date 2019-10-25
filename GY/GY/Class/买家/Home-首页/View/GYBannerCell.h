//
//  GYBannerCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYHomeBanner,GYGoodAdv;
@interface GYBannerCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bannerImg;
/* banner */
@property(nonatomic,strong) GYHomeBanner *banner;
/* banner */
@property(nonatomic,strong) NSDictionary *bannerDict;
/* adv */
@property(nonatomic,strong) GYGoodAdv *adv;
@end

NS_ASSUME_NONNULL_END
