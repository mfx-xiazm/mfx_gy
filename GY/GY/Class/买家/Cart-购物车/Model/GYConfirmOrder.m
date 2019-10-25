//
//  GYConfirmOrder.m
//  GY
//
//  Created by 夏增明 on 2019/10/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYConfirmOrder.h"

@implementation GYConfirmOrder
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"defaultAddress":[GYConfirmAddress class],
             @"userInvoice":[GYUserInvoice class],
             @"goodsData":[GYConfirmGoods class]
             };
}
@end

@implementation GYConfirmAddress

@end

@implementation GYUserInvoice

@end

@implementation GYConfirmGoods
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsDetail":[GYConfirmGoodsDetail class]};
}
@end

@implementation GYConfirmGoodsDetail

@end

