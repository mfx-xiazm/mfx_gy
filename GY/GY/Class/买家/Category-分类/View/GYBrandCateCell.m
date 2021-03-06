//
//  GYBrandCateCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYBrandCateCell.h"
#import "GYBrand.h"
#import "GYSeries.h"
#import "GYWorkType.h"

@interface GYBrandCateCell ()
@property (weak, nonatomic) IBOutlet UILabel *brandName;
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;

@end
@implementation GYBrandCateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBrand:(GYBrand *)brand
{
    _brand = brand;
    self.brandName.text = _brand.brand_name;
    if (_brand.brand_id && _brand.brand_id.length) {
        [self.brandImg sd_setImageWithURL:[NSURL URLWithString:_brand.brand_img]];
    }else{// 全部
        self.brandImg.image = HXGetImage(_brand.brand_img);
    }
}
-(void)setSeries:(GYSeries *)series
{
    _series = series;
    self.seriesLabel.text = _series.series_name;
    if (_series.isSelected) {
        self.seriesLabel.layer.borderColor = HXControlBg.CGColor;
        self.seriesLabel.backgroundColor = HXControlBg;
        self.seriesLabel.textColor = [UIColor whiteColor];
    }else{
        self.seriesLabel.layer.borderColor = [UIColor blackColor].CGColor;
        self.seriesLabel.backgroundColor = [UIColor whiteColor];
        self.seriesLabel.textColor = [UIColor blackColor];
    }
}
-(void)setWorkType:(GYWorkType *)workType
{
    _workType = workType;
    
    self.seriesLabel.text = _workType.set_val;
    if (_workType.isSelected) {
        self.seriesLabel.layer.borderColor = HXControlBg.CGColor;
        self.seriesLabel.backgroundColor = HXControlBg;
        self.seriesLabel.textColor = [UIColor whiteColor];
    }else{
        self.seriesLabel.layer.borderColor = [UIColor blackColor].CGColor;
        self.seriesLabel.backgroundColor = [UIColor whiteColor];
        self.seriesLabel.textColor = [UIColor blackColor];
    }
}
@end
