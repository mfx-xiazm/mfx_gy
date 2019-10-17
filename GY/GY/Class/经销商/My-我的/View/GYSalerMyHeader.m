//
//  GYSalerMyHeader.m
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYSalerMyHeader.h"

@implementation GYSalerMyHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)myHeaderBtnClicked:(UIButton *)sender {
    if (self.salerMyHeaderBtnClickedCall) {
        self.salerMyHeaderBtnClickedCall(sender.tag);
    }
}
@end
