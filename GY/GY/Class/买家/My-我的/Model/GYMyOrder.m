//
//  GYMyOrder.m
//  GY
//
//  Created by 夏增明 on 2019/10/23.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyOrder.h"

@implementation GYMyOrder
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods":[GYMyOrderGoods class]
             };
}
@end

@implementation GYMyOrderGoods

@end
