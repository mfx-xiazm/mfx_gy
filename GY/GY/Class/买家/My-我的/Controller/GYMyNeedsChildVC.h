//
//  GYMyNeedsChildVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYMyNeedsChildVC : HXBaseViewController
/* 状态 1查询未接单 2查询已接单 */
@property(nonatomic,assign) NSInteger task_status;
@end

NS_ASSUME_NONNULL_END
