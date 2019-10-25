//
//  GYBrandCateCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYBrand,GYSeries;
@interface GYBrandCateCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *seriesLabel;
/* 品牌 */
@property(nonatomic,strong) GYBrand *brand;
/* 系列 */
@property(nonatomic,strong) GYSeries *series;
@end

NS_ASSUME_NONNULL_END
