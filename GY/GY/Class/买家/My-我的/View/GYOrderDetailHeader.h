//
//  GYOrderDetailHeader.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYMyOrder,GYMyRefund;
typedef void(^lookLogisCall)(void);
@interface GYOrderDetailHeader : UIView
/* 订单详情 */
@property(nonatomic,strong) GYMyOrder *orderDetail;
/* 退款订单详情 */
@property(nonatomic,strong) GYMyRefund *refundDetail;
/* 查看物流 */
@property(nonatomic,copy) lookLogisCall lookLogisCall;
@end

NS_ASSUME_NONNULL_END
