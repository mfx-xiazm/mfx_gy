//
//  GYMyRefund.m
//  GY
//
//  Created by 夏增明 on 2019/10/23.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyRefund.h"

@implementation GYMyRefund
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods":[GYMyRefundGoods class]
             };
}
@end

@implementation GYMyRefundGoods

@end
