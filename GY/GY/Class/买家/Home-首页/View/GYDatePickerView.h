//
//  GYDatePickerView.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^pushTimePickerBlock)(NSDate *startDate,NSDate *endDate);

@interface GYDatePickerView : UIView
@property (nonatomic, copy) pushTimePickerBlock action;

@end

NS_ASSUME_NONNULL_END
