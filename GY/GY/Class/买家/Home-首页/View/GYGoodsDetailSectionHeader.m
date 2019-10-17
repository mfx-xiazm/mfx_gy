//
//  GYGoodsDetailSectionHeader.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYGoodsDetailSectionHeader.h"

@implementation GYGoodsDetailSectionHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)moreClicked:(UIButton *)sender {
    if (self.moreClickedCall) {
        self.moreClickedCall();
    }
}

@end
