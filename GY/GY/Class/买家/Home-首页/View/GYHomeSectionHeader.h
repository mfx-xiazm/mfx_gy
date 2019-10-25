//
//  GYHomeSectionHeader.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYHomeCate;
typedef void(^sectionCateCall)(void);
@interface GYHomeSectionHeader : UICollectionReusableView
/* 分类 */
@property(nonatomic,strong) GYHomeCate *cate;
/* 点击 */
@property(nonatomic,copy) sectionCateCall sectionCateCall;
@end

NS_ASSUME_NONNULL_END
