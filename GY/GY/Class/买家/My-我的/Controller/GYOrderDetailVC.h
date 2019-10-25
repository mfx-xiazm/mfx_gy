//
//  GYOrderDetailVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class GYOrderPay;
typedef void(^orderHandleCall)(NSInteger type);
@interface GYOrderDetailVC : HXBaseViewController
/* 订单id */
@property(nonatomic,copy) NSString *oid;
/* 退款id */
@property(nonatomic,copy) NSString *refund_id;
/* 支付信息 */
@property(nonatomic,strong) GYOrderPay *orderPay;
/* 订单操作  0 取消订单 1支付订单 2申请退款 3确认收货 4评价*/
@property(nonatomic,copy) orderHandleCall orderHandleCall;
@end

NS_ASSUME_NONNULL_END
