//
//  GYMyBillCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYMyBill;
@interface GYMyBillCell : UITableViewCell
/* 账单 */
@property(nonatomic,strong) GYMyBill *bill;
@end

NS_ASSUME_NONNULL_END
