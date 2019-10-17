//
//  GYMyHeader.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyHeader.h"

@implementation GYMyHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)myHeaderBtnClicked:(UIButton *)sender {
    if (self.myHeaderBtnClickedCall) {
        self.myHeaderBtnClickedCall(sender.tag);
    }
}

@end
