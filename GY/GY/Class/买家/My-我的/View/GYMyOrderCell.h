//
//  GYMyOrderCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYMyRefund,GYMyOrderGoods;
@interface GYMyOrderCell : UITableViewCell
/* 退款 */
@property(nonatomic,strong) GYMyRefund *refund;
/* 订单 */
@property(nonatomic,strong) GYMyOrderGoods *goods;
@end

NS_ASSUME_NONNULL_END
