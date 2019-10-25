//
//  GYInvoiceVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class GYUserInvoice;
typedef void(^saveInvoiceCall)(void);
@interface GYInvoiceVC : HXBaseViewController
/* 发票 */
@property(nonatomic,strong) GYUserInvoice *userInvoice;
/* 点击 */
@property(nonatomic,copy) saveInvoiceCall saveInvoiceCall;
@end

NS_ASSUME_NONNULL_END
