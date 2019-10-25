//
//  GYBrandCateCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYBrand,GYSeries,GYWorkType;
@interface GYBrandCateCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *seriesLabel;
/* 品牌 */
@property(nonatomic,strong) GYBrand *brand;
/* 系列 */
@property(nonatomic,strong) GYSeries *series;
/* 需求类型 */
@property(nonatomic,strong) GYWorkType *workType;
@end

NS_ASSUME_NONNULL_END
