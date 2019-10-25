//
//  GYChooseClassFooter.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYChooseClassFooter.h"

@implementation GYChooseClassFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)numChangeClicked:(UIButton *)sender {
    if (sender.tag) {// +
        if ([self.buy_num.text integerValue] + 1 > self.stock_num) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"库存不足"];
            return;
        }
        self.buy_num.text = [NSString stringWithFormat:@"%zd",[self.buy_num.text integerValue] + 1];
    }else{// -
        if ([self.buy_num.text integerValue] - 1 < 1) {
            return;
        }
        self.buy_num.text = [NSString stringWithFormat:@"%zd",[self.buy_num.text integerValue] - 1];
    }
    if (self.buyNumCall) {
        self.buyNumCall([self.buy_num.text integerValue]);
    }
}

@end
