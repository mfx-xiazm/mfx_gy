//
//  GYMyAddressVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class GYConfirmAddress;
typedef void(^getAddressCall)(GYConfirmAddress *address);
@interface GYMyAddressVC : HXBaseViewController
/* 选择 */
@property(nonatomic,copy) getAddressCall getAddressCall;
@end

NS_ASSUME_NONNULL_END
