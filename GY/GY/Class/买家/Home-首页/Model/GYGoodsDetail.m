//
//  GYGoodsDetail.m
//  GY
//
//  Created by 夏增明 on 2019/10/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYGoodsDetail.h"
#import "GYGoodsCommentLayout.h"

@implementation GYGoodsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"good_adv":[GYGoodAdv class],
             @"spec":[GYGoodSpec class],
             @"eva":[GYGoodsComment class],
             };
}
-(void)setEva:(GYGoodsComment *)eva
{
    _eva = eva;
    if (_eva.evl_id && _eva.evl_id.length) {
        GYGoodsCommentLayout *Layout = [[GYGoodsCommentLayout alloc] initWithModel:_eva];
        _evaLayout = Layout;
    }
}

-(NSInteger)buyNum
{
    if (_buyNum>0) {
        return _buyNum;
    }
    return 1;
}
@end

@implementation GYGoodAdv


@end

@implementation GYGoodSpec
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"spec_val":[GYGoodSubSpec class]
             };
}

@end

@implementation GYGoodSubSpec

@end
