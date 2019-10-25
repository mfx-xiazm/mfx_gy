//
//  GYMyBill.h
//  GY
//
//  Created by 夏增明 on 2019/10/23.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GYMyBillInfo;
@interface GYMyBill : NSObject
@property(nonatomic,copy) NSString *finance_log_id;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *finance_log_type;
@property(nonatomic,copy) NSString *finance_log_title;
@property(nonatomic,copy) NSString *finance_log_desc;
@property(nonatomic,copy) NSString *amount;
@property(nonatomic,copy) NSString *finance_balance;
@property(nonatomic,copy) NSString *ref_id;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,strong) GYMyBillInfo *info;
@end

@interface GYMyBillInfo : NSObject
@property(nonatomic,copy) NSString *oid;
@property(nonatomic,copy) NSString *order_no;
@property(nonatomic,copy) NSString *pay_type;

@property(nonatomic,copy) NSString *member_order_id;
@property(nonatomic,copy) NSString *member_order_no;
@end
NS_ASSUME_NONNULL_END
