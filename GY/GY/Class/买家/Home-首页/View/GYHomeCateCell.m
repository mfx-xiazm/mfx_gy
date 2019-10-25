//
//  GYHomeCateCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYHomeCateCell.h"
#import "GYHomeData.h"

@interface GYHomeCateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cateImg;
@property (weak, nonatomic) IBOutlet UILabel *cateName;

@end
@implementation GYHomeCateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTopCate:(GYHomeTopCate *)topCate
{
    _topCate = topCate;
    self.cateName.text = _topCate.cate_name;
    self.cateImg.image = HXGetImage(_topCate.image_name);
}
@end
