//
//  GYShopGoodsCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYHomeCateGood;
@interface GYShopGoodsCell : UICollectionViewCell
/* 商品 */
@property(nonatomic,strong) GYHomeCateGood *cateGood;
@end

NS_ASSUME_NONNULL_END
