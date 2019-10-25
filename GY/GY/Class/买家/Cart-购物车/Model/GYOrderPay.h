//
//  GYOrderPay.h
//  GY
//
//  Created by 夏增明 on 2019/10/22.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GYPayAccount;
@interface GYOrderPay : NSObject
@property(nonatomic,copy) NSString *order_no;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,strong) NSArray<GYPayAccount *> *account_data;
@end

@interface GYPayAccount : NSObject
@property(nonatomic,copy) NSString *set_id;
@property(nonatomic,copy) NSString *set_type;
@property(nonatomic,copy) NSString *set_val;
@end
NS_ASSUME_NONNULL_END
