//
//  GYBigCateCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYGoodsCate,GYRegion;
@interface GYBigCateCell : UITableViewCell
/* 分类 */
@property(nonatomic,strong) GYGoodsCate *cate;
/* 地区 */
@property(nonatomic,strong) GYRegion *region;
@end

NS_ASSUME_NONNULL_END
