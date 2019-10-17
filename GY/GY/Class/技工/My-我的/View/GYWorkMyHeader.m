//
//  GYWorkMyHeader.m
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYWorkMyHeader.h"

@implementation GYWorkMyHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)myHeaderBtnClicked:(UIButton *)sender {
    if (self.workMyHeaderBtnClickedCall) {
        self.workMyHeaderBtnClickedCall(sender.tag);
    }
}

@end
