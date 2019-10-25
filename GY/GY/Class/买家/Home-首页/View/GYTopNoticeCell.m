//
//  GYTopNoticeCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYTopNoticeCell.h"
#import "GYHomeData.h"

@interface GYTopNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *noticeTxt;

@end
@implementation GYTopNoticeCell

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setNotice:(GYHomeNotice *)notice
{
    _notice = notice;
    self.noticeTxt.text = _notice.notice_title;
}
@end
