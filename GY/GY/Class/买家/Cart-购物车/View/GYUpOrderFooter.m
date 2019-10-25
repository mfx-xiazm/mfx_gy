//
//  GYUpOrderFooter.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYUpOrderFooter.h"
#import "GYConfirmOrder.h"

@interface GYUpOrderFooter ()
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@end
@implementation GYUpOrderFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setUserInvoice:(GYUserInvoice *)userInvoice
{
    _userInvoice = userInvoice;
    if (self.openPiao.isSelected) {
        self.editBtn.hidden = NO;
        [self.editBtn setTitle:_userInvoice.et_name forState:UIControlStateNormal];
    }else{
        self.editBtn.hidden = YES;
    }
}
- (IBAction)openPiaoClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.editBtn.hidden = NO;
        if (self.userInvoice) {
            [self.editBtn setTitle:_userInvoice.et_name forState:UIControlStateNormal];
        }else{
            [self.editBtn setTitle:@"编辑发票" forState:UIControlStateNormal];
        }
    }else{
        self.editBtn.hidden = YES;
    }
}

- (IBAction)editFapiao:(UIButton *)sender {
    if (self.faPiaoClickedCall) {
        self.faPiaoClickedCall();
    }
}

@end
