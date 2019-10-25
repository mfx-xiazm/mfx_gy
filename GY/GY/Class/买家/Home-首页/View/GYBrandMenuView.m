//
//  GYBrandMenuView.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYBrandMenuView.h"
#import "GYBrandCateCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GYBrand.h"
#import "GYSeries.h"

//遮罩颜色
#define bgColor [UIColor colorWithWhite:0.0 alpha:0.2]
//默认未选中文案颜色
#define unselectColor UIColorFromRGB(0x131d2d)
//默认选中文案颜色
#define selectColor UIColorFromRGB(0xFF9F08)

static NSString *const BrandCateCell = @"BrandCateCell";
@interface GYBrandMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
/** collectionView */
@property (strong, nonatomic) UICollectionView *collectionView;
//是否显示
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) UIView *backGroundView;
/* 选中的品牌 */
@property(nonatomic,strong) GYBrand *selectBrand;
/* 选中的系列 */
@property(nonatomic,strong) GYSeries *selectSeries;
@end
@implementation GYBrandMenuView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT)];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    //列表
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = YES;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYBrandCateCell class]) bundle:nil] forCellWithReuseIdentifier:BrandCateCell];
    
    //遮罩
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _backGroundView.backgroundColor = bgColor;
    _backGroundView.opaque = NO;
    //事件
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuHidden)];
    [_backGroundView addGestureRecognizer:gesture];
    [self addSubview:_backGroundView];
    
    [self addSubview:_collectionView];
}

#pragma mark - 更新数据源
-(void)reloadData {

    _collectionView.frame = CGRectMake(0.f, 0, self.frame.size.width, HX_SCREEN_HEIGHT-180.f);
    
    [_collectionView reloadData];
}

#pragma mark - 触发下拉事件
- (void)menuShowInSuperView:(UIView *)view {
    if (!_show) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(brandMenu_positionInSuperView)]) {
            CGPoint position = [self.delegate brandMenu_positionInSuperView];
            self.frame = CGRectMake(position.x, position.y, self.frame.size.width, HX_SCREEN_HEIGHT - position.y);
        } else {
            self.frame = CGRectMake(0, 0, self.frame.size.width, HX_SCREEN_HEIGHT);
        }
        if (view) {
            [view addSubview:self];
        }else{
            [[UIApplication sharedApplication].keyWindow addSubview:self];
        }
    }
    hx_weakify(self);
    [UIView animateWithDuration:0.2 animations:^{
        hx_strongify(weakSelf);
        strongSelf.backGroundView.backgroundColor = strongSelf.show ? [UIColor colorWithWhite:0.0 alpha:0.0] : bgColor;
        if (strongSelf.transformImageView) {
            strongSelf.transformImageView.transform = strongSelf.show ? CGAffineTransformMakeRotation(0) : CGAffineTransformMakeRotation(M_PI);
        }
    } completion:^(BOOL finished) {
        hx_strongify(weakSelf);
        if (strongSelf.show) {
            [strongSelf removeFromSuperview];
        }
        strongSelf.show = !strongSelf.show;
    }];
    
    self.titleLabel.textColor = HXControlBg;
    
    [self reloadData];
}

#pragma mark - 触发收起事件
- (void)menuHidden {
    if (_show) {
        self.titleLabel.textColor = UIColorFromRGB(0x131D2D);
        hx_weakify(self);
        [UIView animateWithDuration:0.2 animations:^{
            hx_strongify(weakSelf);
            strongSelf.backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            if (strongSelf.transformImageView) {
                strongSelf.transformImageView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
            hx_strongify(weakSelf);
            strongSelf.show = !strongSelf.show;
            [strongSelf removeFromSuperview];
        }];
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    /* 1品牌 2系列 3需求类型 */
    if (self.dataType == 1) {
        return self.dataSource.count;
    }else if (self.dataType == 2) {
        return self.dataSource.count;
    }
    return 17;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYBrandCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BrandCateCell forIndexPath:indexPath];
    
    if (self.dataType == 1) {
        cell.seriesLabel.hidden = YES;
        GYBrand *brand = self.dataSource[indexPath.item];
        cell.brand = brand;
    }else{
        cell.seriesLabel.hidden = NO;
        if (self.dataType == 2) {
            GYSeries *series = self.dataSource[indexPath.item];
            cell.series = series;
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataType == 1) {
        GYBrand *brand = self.dataSource[indexPath.item];
        self.titleLabel.text = brand.brand_name;
    }else if (self.dataType == 2) {
        GYSeries *series = self.dataSource[indexPath.item];
        self.titleLabel.text = series.series_name;
        
        self.selectSeries.isSelected = NO;
        series.isSelected = YES;
        self.selectSeries = series;
    }
    [collectionView reloadData];
    if (self.delegate || [self.delegate respondsToSelector:@selector(brandMenu:didSelectRowAtIndexPath:)]) {
        [self.delegate brandMenu:self didSelectRowAtIndexPath:indexPath];
        [self menuHidden];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataType == 1) {
        CGFloat width = (collectionView.hxn_width - 10*4.0)/3.0;
        CGFloat height = 65.f;
        return CGSizeMake(width, height);
    }else if (self.dataType == 2) {
        CGFloat width = (collectionView.hxn_width - 10*4.0)/3.0;
        CGFloat height = 40.f;
        return CGSizeMake(width, height);
    }else{
        CGFloat width = (collectionView.hxn_width - 10*4.0)/3.0;
        CGFloat height = 40.f;
        return CGSizeMake(width, height);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}
@end
