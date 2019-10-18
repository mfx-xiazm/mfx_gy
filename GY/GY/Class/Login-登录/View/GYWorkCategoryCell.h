//
//  GYWorkCategoryCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYWorkType;

@interface GYWorkCategoryCell : UICollectionViewCell
/* 工种 */
@property(nonatomic,strong) GYWorkType *workType;
@end

NS_ASSUME_NONNULL_END
