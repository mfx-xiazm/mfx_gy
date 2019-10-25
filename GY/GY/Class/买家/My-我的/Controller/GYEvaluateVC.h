//
//  GYEvaluateVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^evaluatSuccessCall)(void);
@interface GYEvaluateVC : HXBaseViewController
/* 订单id */
@property(nonatomic,copy) NSString *oid;
/* 评价成功 */
@property(nonatomic,copy) evaluatSuccessCall evaluatSuccessCall;
@end

NS_ASSUME_NONNULL_END
