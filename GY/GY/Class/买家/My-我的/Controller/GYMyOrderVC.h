//
//  GYMyOrderVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYMyOrderVC : HXBaseViewController
/* 默认选中的索引 */
@property(nonatomic,assign) NSInteger selectIndex;
/** 是否是提交订单页面跳转 */
@property (nonatomic,assign) BOOL isPushOrder;
@end

NS_ASSUME_NONNULL_END
