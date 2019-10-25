//
//  GYMyOrderFooter.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYMyRefund,GYMyOrder;
typedef void(^orderHandleCall)(NSInteger index);
@interface GYMyOrderFooter : UIView
@property (weak, nonatomic) IBOutlet UIView *handleView;
/* 退款 */
@property(nonatomic,strong) GYMyRefund *refund;
/* 订单 */
@property(nonatomic,strong) GYMyOrder *order;
/* 操作 */
@property(nonatomic,copy) orderHandleCall orderHandleCall;
@end

NS_ASSUME_NONNULL_END
