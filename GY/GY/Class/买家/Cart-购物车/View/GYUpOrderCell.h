//
//  GYUpOrderCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYConfirmGoodsDetail;
@interface GYUpOrderCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) GYConfirmGoodsDetail *goods;

@end

NS_ASSUME_NONNULL_END
