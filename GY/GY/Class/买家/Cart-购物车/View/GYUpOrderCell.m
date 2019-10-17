//
//  GYUpOrderCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYUpOrderCell.h"
#import "HXPlaceholderTextView.h"

@interface GYUpOrderCell ()
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;

@end
@implementation GYUpOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.remark.placeholder = @"备注：";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
