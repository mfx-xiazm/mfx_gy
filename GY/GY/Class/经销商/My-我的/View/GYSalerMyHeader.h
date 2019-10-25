//
//  GYSalerMyHeader.h
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYMineData;
typedef void(^salerMyHeaderBtnClickedCall)(NSInteger index);
@interface GYSalerMyHeader : UIView
/* 点击 */
@property(nonatomic,copy) salerMyHeaderBtnClickedCall salerMyHeaderBtnClickedCall;
/* 个人信息 */
@property(nonatomic,strong) GYMineData *mineData;
@end

NS_ASSUME_NONNULL_END
