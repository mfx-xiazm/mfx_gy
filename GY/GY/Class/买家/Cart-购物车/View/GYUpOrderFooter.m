//
//  GYUpOrderFooter.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYUpOrderFooter.h"

@implementation GYUpOrderFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)editFapiao:(UIButton *)sender {
    if (self.faPiaoClickedCall) {
        self.faPiaoClickedCall();
    }
}

@end
