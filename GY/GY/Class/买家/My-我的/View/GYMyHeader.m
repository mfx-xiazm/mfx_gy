//
//  GYMyHeader.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyHeader.h"
#import "GYMineData.h"

@interface GYMyHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *member_dead;
@property (weak, nonatomic) IBOutlet UIImageView *is_vip;

@end
@implementation GYMyHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setMineData:(GYMineData *)mineData
{
    _mineData = mineData;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:_mineData.avatar] placeholderImage:HXGetImage(@"头像")];
    self.user_name.text = _mineData.nick_name;
    self.phone.text = _mineData.phone;
    if ([_mineData.member_id isEqualToString:@"0"]) {
        self.is_vip.hidden = YES;
        self.member_dead.hidden = YES;
    }else{
        self.is_vip.hidden = NO;
        self.member_dead.hidden = NO;
        self.member_dead.text = [NSString stringWithFormat:@"%@到期",_mineData.member_deadline];
    }
}
- (IBAction)myHeaderBtnClicked:(UIButton *)sender {
    if (self.myHeaderBtnClickedCall) {
        self.myHeaderBtnClickedCall(sender.tag);
    }
}

@end
