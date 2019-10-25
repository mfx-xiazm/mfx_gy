//
//  GYMyBill.m
//  GY
//
//  Created by 夏增明 on 2019/10/23.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyBill.h"

@implementation GYMyBill
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"info":[GYMyBillInfo class]
             };
}
@end

@implementation GYMyBillInfo

@end
