//
//  GYChooseClassCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYGoodSubSpec;
@interface GYChooseClassCell : UICollectionViewCell
/* 规格 */
@property(nonatomic,strong) GYGoodSubSpec *subSpec;
@end

NS_ASSUME_NONNULL_END
