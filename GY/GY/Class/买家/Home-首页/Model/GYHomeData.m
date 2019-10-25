//
//  GYHomeData.m
//  GY
//
//  Created by 夏增明 on 2019/10/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYHomeData.h"

@implementation GYHomeData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"homeAdv":[GYHomeBanner class],
             @"homeNotice":[GYHomeNotice class],
             @"homeCate":[GYHomeCate class],
             @"homeTopCate":[GYHomeTopCate class]
             };
}
@end

@implementation GYHomeBanner


@end

@implementation GYHomeNotice


@end

@implementation GYHomeTopCate


@end

@implementation GYHomeCate
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods":[GYHomeCateGood class]
             };
}
@end

@implementation GYHomeCateGood


@end

