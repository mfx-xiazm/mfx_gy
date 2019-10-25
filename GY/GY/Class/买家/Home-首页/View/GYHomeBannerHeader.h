//
//  GYHomeBannerHeader.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYHomeBanner,GYHomeNotice;
typedef void(^bannerOrNoticeCall)(NSInteger type,NSInteger index);
@interface GYHomeBannerHeader : UICollectionReusableView
@property(nonatomic,strong) NSArray<GYHomeBanner *> *homeAdv;
@property(nonatomic,strong) NSArray<GYHomeNotice *> *homeNotice;
/* 点击 */
@property(nonatomic,copy) bannerOrNoticeCall bannerOrNoticeCall;
@end

NS_ASSUME_NONNULL_END
