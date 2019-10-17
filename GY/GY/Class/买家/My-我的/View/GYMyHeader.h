//
//  GYMyHeader.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^myHeaderBtnClickedCall)(NSInteger index);
@interface GYMyHeader : UIView
/* 点击 */
@property(nonatomic,copy) myHeaderBtnClickedCall myHeaderBtnClickedCall;
@end

NS_ASSUME_NONNULL_END
