//
//  GYGoodsComment.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYGoodsComment.h"

@implementation GYGoodsComment
-(void)setAvatar:(NSString *)avatar
{
    _avatar = avatar;
    _portrait = _avatar;
}
-(void)setEvl_content:(NSString *)evl_content
{
    _evl_content = evl_content;
    _dsp = _evl_content;
}
-(void)setNick_name:(NSString *)nick_name
{
    _nick_name = nick_name;
    _nick = _nick_name;
}
-(void)setCreate_time:(NSString *)create_time
{
    _create_time = create_time;
    _creatTime = _create_time;
}
-(void)setEvaImgData:(NSArray *)evaImgData
{
    _evaImgData = evaImgData;
    /*
     "evl_img_id": 87,
     "evl_id": 75,
     "img_src": "http:\/\/gongliujie.mfxapp.com\/storage\/tou\/2019-09-23-16-32-13_5d88830d43923.png",
     "create_time": "2019-09-23 16:32:14"
     */
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in _evaImgData) {
        [temp addObject:dict[@"img_src"]];
    }
    _photos = temp;
}
-(void)setDsp:(NSString *)dsp
{
    if (!dsp) {
        return;
    }
    _dsp = dsp;
    if (!_dsp.length) {
        _dsp = @"";
    }
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:_dsp];
    text.yy_font = [UIFont systemFontOfSize:14];// 文字大小
    text.yy_lineSpacing = 5;//行高
    
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(HX_SCREEN_WIDTH - 10*2, CGFLOAT_MAX)];
    
    YYTextLayout * layout = [YYTextLayout layoutWithContainer:container text:text];
    
    // 默认最多显示6行，大于6行折叠，并显示全文按钮
    if (layout.rowCount <= 6) {
        _shouldShowMoreButton = NO;
    }else{
        _shouldShowMoreButton = YES;
    }
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}
@end
