//
//  GYMyNeedsCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyNeedsCell.h"
#import "GYMyTasks.h"

@interface GYMyNeedsCell ()
@property (weak, nonatomic) IBOutlet UILabel *task_no;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UIImageView *task_img;
@property (weak, nonatomic) IBOutlet UILabel *task_title;
@property (weak, nonatomic) IBOutlet UILabel *task_type;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *task_time;
@property (weak, nonatomic) IBOutlet UILabel *task_address;

@end
@implementation GYMyNeedsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTask:(GYMyTasks *)task
{
    _task = task;
    self.task_no.text = [NSString stringWithFormat:@"单号：%@",_task.task_no];
    self.create_time.text = _task.create_time;
    [self.task_img sd_setImageWithURL:[NSURL URLWithString:_task.task_img]];
    [self.task_title setTextWithLineSpace:5.f withString:_task.task_title withFont:[UIFont systemFontOfSize:13]];
    self.task_type.text = _task.task_type;
    self.price.text = [NSString stringWithFormat:@"价格：%@",_task.task_price];
    self.task_time.text = [NSString stringWithFormat:@"%@ %@",_task.task_date,_task.task_time];
    self.task_address.text = [NSString stringWithFormat:@"%@%@%@",_task.province_name,_task.city_name,_task.address];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
