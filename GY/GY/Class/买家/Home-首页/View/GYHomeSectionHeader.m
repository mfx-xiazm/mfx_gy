//
//  GYHomeSectionHeader.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYHomeSectionHeader.h"
#import "GYHomeData.h"

@interface GYHomeSectionHeader ()
@property (weak, nonatomic) IBOutlet UILabel *cateName;
@property (weak, nonatomic) IBOutlet UIImageView *cateImg;

@end
@implementation GYHomeSectionHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cateClicked)];
    [self.cateImg addGestureRecognizer:tap];
}
-(void)cateClicked
{
    if (self.sectionCateCall) {
        self.sectionCateCall();
    }
}
-(void)setCate:(GYHomeCate *)cate
{
    _cate = cate;
    self.cateName.text = _cate.cate_name;
    [self.cateImg sd_setImageWithURL:[NSURL URLWithString:_cate.home_phone_img]];
}
@end
