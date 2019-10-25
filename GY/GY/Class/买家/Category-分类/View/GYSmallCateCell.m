//
//  GYSmallCateCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYSmallCateCell.h"
#import "GYGoodsCate.h"

@interface GYSmallCateCell ()
@property (weak, nonatomic) IBOutlet UILabel *cateName;

@end
@implementation GYSmallCateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setSubCate:(GYGoodsSubCate *)subCate
{
    _subCate = subCate;
    self.cateName.text = _subCate.cate_name;
    if (_subCate.isSelected) {
        self.cateName.backgroundColor = HXControlBg;
        self.cateName.textColor = [UIColor whiteColor];
    }else{
        self.cateName.backgroundColor = HXGlobalBg;
        self.cateName.textColor = [UIColor blackColor];
    }
}
@end
