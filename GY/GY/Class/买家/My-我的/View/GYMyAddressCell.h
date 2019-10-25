//
//  GYMyAddressCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYConfirmAddress;
typedef void(^editClickedCall)(void);
@interface GYMyAddressCell : UITableViewCell
/* 点击 */
@property(nonatomic,copy) editClickedCall editClickedCall;
/* 地址 */
@property(nonatomic,strong) GYConfirmAddress *address;
@end

NS_ASSUME_NONNULL_END
