//
//  GYChooseClassCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYChooseClassCell.h"
#import "GYGoodsDetail.h"

@interface GYChooseClassCell ()
@property (weak, nonatomic) IBOutlet UILabel *spec_name;
@end
@implementation GYChooseClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setSubSpec:(GYGoodSubSpec *)subSpec
{
    _subSpec = subSpec;
    
    self.spec_name.text = _subSpec.spec_value;
    
    if (_subSpec.isSelected) {
        self.spec_name.textColor = [UIColor whiteColor];
        self.spec_name.backgroundColor = UIColorFromRGB(0xEA4A5C);
        self.spec_name.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        self.spec_name.textColor = [UIColor blackColor];
        self.spec_name.backgroundColor = [UIColor whiteColor];
        self.spec_name.layer.borderColor = [UIColor blackColor].CGColor;
    }
}
@end
