//
//  GYCateMenuView.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYCateMenuView.h"
#import "GYBigCateCell.h"
#import "GYSmallCateCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GYSmallCateHeaderView.h"

//遮罩颜色
#define bgColor [UIColor colorWithWhite:0.0 alpha:0.2]
//默认未选中文案颜色
#define unselectColor UIColorFromRGB(0x131d2d)
//默认选中文案颜色
#define selectColor UIColorFromRGB(0xFF9F08)

static NSString *const BigCateCell = @"BigCateCell";
static NSString *const SmallCateCell = @"SmallCateCell";
static NSString *const SmallCateHeaderView = @"SmallCateHeaderView";

@interface GYCateMenuView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
/** 左边tableView */
@property (strong, nonatomic) UITableView *leftTableView;
/** 右边collectionView */
@property (strong, nonatomic) UICollectionView *rightCollectionView;
//是否显示
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) UIView *backGroundView;

@end

@implementation GYCateMenuView

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
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 90.f, 0) style:UITableViewStylePlain];
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.estimatedSectionHeaderHeight = 0;
    _leftTableView.estimatedSectionFooterHeight = 0;
    [_leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYBigCateCell class]) bundle:nil] forCellReuseIdentifier:BigCateCell];
    
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = YES;
    _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(90.f, 0, self.frame.size.width-90.f, 0) collectionViewLayout:flowLayout];
    _rightCollectionView.dataSource = self;
    _rightCollectionView.delegate = self;
    _rightCollectionView.backgroundColor = [UIColor whiteColor];
    
    [_rightCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSmallCateCell class]) bundle:nil] forCellWithReuseIdentifier:SmallCateCell];
    [_rightCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSmallCateHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SmallCateHeaderView];
    
    //遮罩
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _backGroundView.backgroundColor = bgColor;
    _backGroundView.opaque = NO;
    //事件
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuHidden)];
    [_backGroundView addGestureRecognizer:gesture];
    [self addSubview:_backGroundView];
    
    [self addSubview:_leftTableView];
    [self addSubview:_rightCollectionView];
}

#pragma mark - 更新数据源
-(void)reloadData {
    _leftTableView.rowHeight = 44.f;
    _leftTableView.frame = CGRectMake(0, 0, 90.f, HX_SCREEN_HEIGHT-180.f);
    
    _rightCollectionView.frame = CGRectMake(90.f, 0, self.frame.size.width-90.f, HX_SCREEN_HEIGHT-180.f);

    [_leftTableView reloadData];
    [_rightCollectionView reloadData];
}
#pragma mark - 触发下拉事件
- (void)menuShowInSuperView:(UIView *)view {
    if (!_show) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cateMenu_positionInSuperView)]) {
            CGPoint position = [self.delegate cateMenu_positionInSuperView];
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
#pragma mark -- UITableView 数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYBigCateCell *cell = [tableView dequeueReusableCellWithIdentifier:BigCateCell forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 16;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 2;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYSmallCateCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SmallCateCell forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    self.titleLabel.text = [self.dataSource menu_titleForRow:indexPath.row];
    if (self.delegate || [self.delegate respondsToSelector:@selector(cateMenu:didSelectRowAtIndexPath:)]) {
        [self.delegate cateMenu:self didSelectRowAtIndexPath:indexPath];
        [self menuHidden];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.hxn_width - 10*3.0)/2.0;
    CGFloat height = 35.f;
    return CGSizeMake(width, height);
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
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        GYSmallCateHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SmallCateHeaderView forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 44);
}


@end
