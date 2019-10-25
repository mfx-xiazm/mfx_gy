//
//  GYMember.h
//  GY
//
//  Created by 夏增明 on 2019/10/23.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYMember : NSObject
@property(nonatomic,copy) NSString *member_id;
@property(nonatomic,copy) NSString *utype;
@property(nonatomic,copy) NSString *member_type_name;
@property(nonatomic,copy) NSString *member_type_month;
@property(nonatomic,copy) NSString *member_amount;
@end

NS_ASSUME_NONNULL_END
