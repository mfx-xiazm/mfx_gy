//
//  GYGoodsCate.m
//  GY
//
//  Created by 夏增明 on 2019/10/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYGoodsCate.h"

@implementation GYGoodsCate
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"sub":[GYGoodsSubCate class]
             };
}
@end

@implementation GYGoodsSubCate

@end
