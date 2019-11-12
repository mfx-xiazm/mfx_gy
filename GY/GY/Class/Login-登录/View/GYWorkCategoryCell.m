//
//  GYWorkCategoryCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYWorkCategoryCell.h"
#import "GYWorkType.h"

@interface GYWorkCategoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *cateLabel;

@end
@implementation GYWorkCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setWorkType:(GYWorkType *)workType
{
    _workType = workType;
    self.cateLabel.text = _workType.set_val;
    if (_workType.isSelected) {
        self.cateLabel.layer.borderColor = HXControlBg.CGColor;
        self.cateLabel.backgroundColor = HXControlBg;
        self.cateLabel.textColor = [UIColor whiteColor];
    }else{
        self.cateLabel.layer.borderColor = [UIColor blackColor].CGColor;
        self.cateLabel.backgroundColor = [UIColor whiteColor];
        self.cateLabel.textColor = [UIColor blackColor];
    }
}
@end
