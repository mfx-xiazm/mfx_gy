//
//  GYOrderPay.m
//  GY
//
//  Created by 夏增明 on 2019/10/22.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYOrderPay.h"

@implementation GYOrderPay
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"account_data":[GYPayAccount class]
             };
}
@end

@implementation GYPayAccount

@end
