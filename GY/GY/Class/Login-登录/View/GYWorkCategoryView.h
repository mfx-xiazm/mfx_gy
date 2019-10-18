//
//  GYWorkCategoryView.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^workCateCall)(NSInteger index);
@interface GYWorkCategoryView : UIView
/* 技术工种 */
@property(nonatomic,strong) NSArray *workTypes;
/* 点击 */
@property(nonatomic,copy) workCateCall workCateCall;
@end

NS_ASSUME_NONNULL_END
