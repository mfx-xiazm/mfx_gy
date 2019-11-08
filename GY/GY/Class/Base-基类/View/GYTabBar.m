//
//  GYTabBar.m
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYTabBar.h"

@interface GYTabBar ()
/* 自定义大按钮 */
@property(nonatomic,strong) UIButton *plusBtn;
@end

@implementation GYTabBar

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateHighlighted];
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}
-(void)plusClick {
    if ([self.rcDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.rcDelegate tabBarDidClickPlusButton:self];
    }
}
-(void)layoutSubviews {
    
    [super layoutSubviews];

    CGFloat tabBarButtonW  = HX_SCREEN_WIDTH / 3.0;
    self.plusBtn.hxn_width = tabBarButtonW;
    self.plusBtn.hxn_height = self.hxn_height;
    
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.hxn_width = tabBarButtonW;
            child.hxn_x = tabbarButtonIndex *tabBarButtonW;
            tabbarButtonIndex ++;
            if (tabbarButtonIndex == 1) {
                tabbarButtonIndex ++;
            }
        }
    }
    self.plusBtn.hxn_centerX = HX_SCREEN_WIDTH *0.5;
    self.plusBtn.hxn_y = 0;
}
@end
