//
//  GYInvoiceDetailFooter.h
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYMyOrder,GYMyRefund;
@interface GYInvoiceDetailFooter : UIView
/* 订单详情 */
@property(nonatomic,strong) GYMyOrder *orderDetail;
/* 退款订单详情 */
@property(nonatomic,strong) GYMyRefund *refundDetail;
@end

NS_ASSUME_NONNULL_END
