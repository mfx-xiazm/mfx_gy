//
//  GYSmallCateCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYGoodsSubCate,GYSubRegion;
@interface GYSmallCateCell : UICollectionViewCell
/* 分类 */
@property(nonatomic,strong) GYGoodsSubCate *subCate;
/* 地区 */
@property(nonatomic,strong) GYSubRegion *subRegion;
@end

NS_ASSUME_NONNULL_END
