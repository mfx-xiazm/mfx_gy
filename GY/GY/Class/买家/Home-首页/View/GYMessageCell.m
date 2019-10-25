//
//  GYMessageCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMessageCell.h"
#import "GYMessage.h"

@interface GYMessageCell ()
@property (weak, nonatomic) IBOutlet UIView *msgState;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation GYMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMsg:(GYMessage *)msg
{
    _msg = msg;
    if (_msg.is_read) {
        self.msgState.hidden = YES;
    }else{
        self.msgState.hidden = NO;
    }
    self.title.text = _msg.msg_content;
    self.time.text = _msg.create_time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
