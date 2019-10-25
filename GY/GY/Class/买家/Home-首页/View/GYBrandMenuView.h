//
//  GYBrandMenuView.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYBrandMenuView;
@protocol GYBrandMenuViewDelegate <NSObject>

@required
//出现位置
- (CGPoint)brandMenu_positionInSuperView;
//点击事件
- (void)brandMenu:(GYBrandMenuView *)menu  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GYBrandMenuView : UIView
@property (nonatomic, strong) UIColor *titleHightLightColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign ,readonly) BOOL show;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *transformImageView;
@property (nonatomic, weak) id<GYBrandMenuViewDelegate> delegate;
/* 1品牌 2系列 3需求类型 */
@property (nonatomic, assign) NSInteger dataType;
/* 数据源 */
@property(nonatomic,strong) NSArray *dataSource;
- (void)reloadData;
- (void)menuHidden;
- (void)menuShowInSuperView:(UIView * _Nullable)view;
@end

NS_ASSUME_NONNULL_END
