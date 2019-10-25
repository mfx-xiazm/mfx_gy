//
//  GYSpecialGoodsCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYGoods,GYMyGoods;
@interface GYSpecialGoodsCell : UITableViewCell
/* 商品 */
@property(nonatomic,strong) GYGoods *goods;
/* 我的产品 */
@property(nonatomic,strong) GYMyGoods *myGoods;
@end

NS_ASSUME_NONNULL_END
