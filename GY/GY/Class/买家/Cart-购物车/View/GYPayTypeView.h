//
//  GYPayTypeView.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYOrderPay;
typedef void(^confirmPayCall)(NSInteger type);
@interface GYPayTypeView : UIView
/* 支付信息 */
@property(nonatomic,strong) GYOrderPay *orderPay;
/* 确认支付 */
@property(nonatomic,copy) confirmPayCall confirmPayCall;
@end

NS_ASSUME_NONNULL_END
