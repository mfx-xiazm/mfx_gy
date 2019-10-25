//
//  GYBigCateCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYBigCateCell.h"
#import "GYGoodsCate.h"

@interface GYBigCateCell ()
@property (weak, nonatomic) IBOutlet UILabel *cateName;

@end
@implementation GYBigCateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCate:(GYGoodsCate *)cate
{
    _cate = cate;
    self.cateName.text = _cate.cate_name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.cateName.backgroundColor = selected ? [UIColor whiteColor] : HXGlobalBg;
    self.cateName.textColor = selected ? HXControlBg : UIColorFromRGB(0x1A1A1A);
    //self.highlighted = selected;
    self.cateName.font = selected ?[UIFont boldSystemFontOfSize:14] : [UIFont systemFontOfSize:14];
}


@end
