//
//  GYUpOrderVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^upOrderSuccessCall)(void);
@interface GYUpOrderVC : HXBaseViewController
/* 购物车ID 选择多个用逗号隔开 */
@property(nonatomic,copy) NSString *cart_ids;
/* 购物车跳转 */
@property(nonatomic,assign) BOOL isCartPush;
/* 商品id */
@property(nonatomic,copy) NSString *goods_id;
/* 商品数量 */
@property(nonatomic,copy) NSString *goods_num;
/* 商品规格 */
@property(nonatomic,copy) NSString *spec_values;
/* 订单提交成功 */
@property(nonatomic,copy) upOrderSuccessCall upOrderSuccessCall;
@end

NS_ASSUME_NONNULL_END
