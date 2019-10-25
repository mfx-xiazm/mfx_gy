//
//  GYRegion.m
//  GY
//
//  Created by 夏增明 on 2019/10/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYRegion.h"

@implementation GYRegion
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"city":[GYSubRegion class]};
}
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"cityid":@"id"};
}
@end

@implementation GYSubRegion
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"cityid":@"id"};
}
@end
