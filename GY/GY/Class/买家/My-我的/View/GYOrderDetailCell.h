//
//  GYOrderDetailCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYMyOrderGoods,GYMyRefundGoods;
@interface GYOrderDetailCell : UITableViewCell
/* 订单商品 */
@property(nonatomic,strong) GYMyOrderGoods *goods;
/* 退款商品 */
@property(nonatomic,strong) GYMyRefundGoods *refundGoods;
@end

NS_ASSUME_NONNULL_END
