//
//  GYMyCollectCell.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyCollectCell.h"
#import "GYMyCollect.h"

@interface GYMyCollectCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_title;
@property (weak, nonatomic) IBOutlet UILabel *goods_type;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;

@property (weak, nonatomic) IBOutlet UIButton *is_selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img1;
@property (weak, nonatomic) IBOutlet UILabel *goods_title1;
@property (weak, nonatomic) IBOutlet UILabel *goods_type1;
@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *market_price1;
@end
@implementation GYMyCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setCollect:(GYMyCollect *)collect
{
    _collect = collect;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_collect.cover_img]];
    [self.goods_title setTextWithLineSpace:5.f withString:_collect.goods_name withFont:[UIFont systemFontOfSize:13]];
    if ([_collect.goods_type isEqualToString:@"1"]) {
        self.goods_type.text = @" 直营商品 ";
    }else if ([_collect.goods_type isEqualToString:@"2"]) {
        self.goods_type.text = @" 积压甩卖 ";
    }else{
        self.goods_type.text = @" 经销商商品 ";
    }
//    self.goods_type.text = [NSString stringWithFormat:@" %@ ",_collect.goods_type_name];
    self.price.text = [NSString stringWithFormat:@"会员价%@",_collect.price];
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_collect.market_price]];
    
    [self.cover_img1 sd_setImageWithURL:[NSURL URLWithString:_collect.cover_img]];
    [self.goods_title1 setTextWithLineSpace:5.f withString:_collect.goods_name withFont:[UIFont systemFontOfSize:13]];
    self.goods_type1.text = [NSString stringWithFormat:@" %@ ",_collect.goods_type_name];
    self.price1.text = [NSString stringWithFormat:@"会员价%@",_collect.price];
    [self.market_price1 setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_collect.market_price]];
    
    self.is_selectBtn.selected = _collect.isSelect;
}
- (IBAction)selectClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    _collect.isSelect = sender.isSelected;
    if (self.selectCollectCall) {
        self.selectCollectCall();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
