//
//  GYSpecialGoodsVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYSpecialGoodsVC : HXBaseViewController
/* 标题 */
@property(nonatomic,copy) NSString *navTitle;
/* 类型 1专区直营 2积压甩卖 */
@property(nonatomic,assign) NSInteger dataType;
@end

NS_ASSUME_NONNULL_END
