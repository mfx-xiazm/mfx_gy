//
//  GYVipMemberCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYVipMemberCell.h"
#import "GYMember.h"

@interface GYVipMemberCell ()
@property (weak, nonatomic) IBOutlet UILabel *member_type;
@property (weak, nonatomic) IBOutlet UILabel *price_month;

@end
@implementation GYVipMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMamber:(GYMember *)mamber
{
    _mamber = mamber;
    
    self.member_type.text = _mamber.member_type_name;
    [self.price_month setFontAttributedText:[NSString stringWithFormat:@"%@元/%@个月",_mamber.member_amount,_mamber.member_type_month] andChangeStr:[NSString stringWithFormat:@"元/%@个月",_mamber.member_type_month] andFont:[UIFont systemFontOfSize:13]];
}
@end
