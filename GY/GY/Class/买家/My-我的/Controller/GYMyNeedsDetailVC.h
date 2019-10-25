//
//  GYMyNeedsDetailVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^rePublishCall)(void);
@interface GYMyNeedsDetailVC : HXBaseViewController
/* 需求id */
@property(nonatomic,copy) NSString *task_id;
/* 重新发布回调 */
@property(nonatomic,copy) rePublishCall rePublishCall;
/* 是否已接单的详情查看 */
@property(nonatomic,assign) BOOL isTaked;
/* 是否要接单的详情查看 */
@property(nonatomic,assign) BOOL isToTake;
@end

NS_ASSUME_NONNULL_END
