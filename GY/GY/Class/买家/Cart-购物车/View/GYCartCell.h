//
//  GYCartCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYCartData;
typedef void(^cartHandleCall)(NSInteger index);
@interface GYCartCell : UITableViewCell
/* 购物车 */
@property(nonatomic,strong) GYCartData *cart;
/* 点击 */
@property(nonatomic,copy) cartHandleCall cartHandleCall;
@end

NS_ASSUME_NONNULL_END
