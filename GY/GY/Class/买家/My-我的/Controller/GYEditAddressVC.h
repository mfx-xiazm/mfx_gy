//
//  GYEditAddressVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class GYConfirmAddress;
typedef void(^editSuccessCall)(NSInteger type);
@interface GYEditAddressVC : HXBaseViewController
/* 地址 */
@property(nonatomic,strong) GYConfirmAddress *address;
/* 新增或者编辑成功 1新增 2编辑 3删除*/
@property(nonatomic,copy) editSuccessCall editSuccessCall;
@end

NS_ASSUME_NONNULL_END
