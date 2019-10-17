//
//  GYMyAddressCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^editClickedCall)(void);
@interface GYMyAddressCell : UITableViewCell
/* 点击 */
@property(nonatomic,copy) editClickedCall editClickedCall;
@end

NS_ASSUME_NONNULL_END
