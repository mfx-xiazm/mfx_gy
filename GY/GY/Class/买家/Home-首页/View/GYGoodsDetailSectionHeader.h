//
//  GYGoodsDetailSectionHeader.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^moreClickedCall)(void);
@interface GYGoodsDetailSectionHeader : UIView
/* 点击 */
@property(nonatomic,copy) moreClickedCall moreClickedCall;
@end

NS_ASSUME_NONNULL_END
