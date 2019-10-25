//
//  GYCateMenuView.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYCateMenuView;

@protocol GYCateMenuViewDelegate <NSObject>

@required
//出现位置
- (CGPoint)cateMenu_positionInSuperView;
//点击事件
- (void)cateMenu:(GYCateMenuView *)menu  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GYCateMenuView : UIView

@property (nonatomic, strong) UIColor *titleHightLightColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign ,readonly) BOOL show;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *transformImageView;
@property (nonatomic, weak) id<GYCateMenuViewDelegate> delegate;
/* 1分类 2地区 */
@property (nonatomic, assign) NSInteger dataType;
/* 选中的左侧大分类索引 */
@property(nonatomic,assign) NSInteger selectIndex;
/** 数据 */
@property(nonatomic,strong) NSArray *dataSource;
- (void)reloadData;
- (void)menuHidden;
- (void)menuShowInSuperView:(UIView * _Nullable)view;
@end

NS_ASSUME_NONNULL_END
