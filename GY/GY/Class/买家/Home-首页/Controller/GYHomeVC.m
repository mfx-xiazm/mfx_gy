//
//  GYHomeVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYHomeVC.h"
#import "HXSearchBar.h"
#import "GYMessageVC.h"
#import "GYHomeCateCell.h"
#import "GYShopGoodsCell.h"
#import "GYHomeSectionHeader.h"
#import "GYHomeBannerHeader.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GYCategoryVC.h"
#import "GYSpecialGoodsVC.h"
#import "GYGoodsDetailVC.h"
#import "GYPublishWorkVC.h"

static NSString *const HomeCateCell = @"HomeCateCell";
static NSString *const ShopGoodsCell = @"ShopGoodsCell";
static NSString *const HomeSectionHeader = @"HomeSectionHeader";
static NSString *const HomeBannerHeader = @"HomeBannerHeader";

@interface GYHomeVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 搜索条 */
@property(nonatomic,strong) HXSearchBar *searchBar;
/* 消息 */
@property(nonatomic,strong) SPButton *msgBtn;
@end

@implementation GYHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 6;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    self.searchBar = searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    
    SPButton *msg = [SPButton buttonWithType:UIButtonTypeCustom];
    msg.imagePosition = SPButtonImagePositionTop;
    msg.imageTitleSpace = 2.f;
    msg.hxn_size = CGSizeMake(40, 40);
    msg.titleLabel.font = [UIFont systemFontOfSize:9];
    [msg setImage:HXGetImage(@"消息") forState:UIControlStateNormal];
    [msg setTitle:@"消息" forState:UIControlStateNormal];
    [msg addTarget:self action:@selector(msgClicked) forControlEvents:UIControlEventTouchUpInside];
    [msg setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    
    self.msgBtn = msg;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:msg];
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHomeCateCell class]) bundle:nil] forCellWithReuseIdentifier:HomeCateCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYShopGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:ShopGoodsCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHomeSectionHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHomeBannerHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeBannerHeader];
}
#pragma mark -- 点击事件
-(void)msgClicked
{
    GYMessageVC *mvc = [GYMessageVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    HXLog(@"搜索条");
    return NO;
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {//分类
        return 6;
    }else if (section == 1) {//推荐商品分组
        return 8;
    }else{//推荐商品分组
        return 8;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    if (section == 0) {//分类
        return 3;
    }else if (section == 1) {//推荐商品分组
        return 2;
    }else{//推荐商品分组
        return 2;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        GYHomeCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCateCell forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1) {//推荐商品分组
        GYShopGoodsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopGoodsCell forIndexPath:indexPath];
        return cell;
    }else{//推荐商品分组
        GYShopGoodsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopGoodsCell forIndexPath:indexPath];
        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(HX_SCREEN_WIDTH,HX_SCREEN_WIDTH*3/5+50.f+20.f);
    }else{
        return CGSizeMake(HX_SCREEN_WIDTH,125.f);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if (indexPath.section == 0) {
            GYHomeBannerHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeBannerHeader forIndexPath:indexPath];
            return header;
        }else{
            GYHomeSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader forIndexPath:indexPath];
            return header;
        }
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        if (indexPath.item == 0) {
            GYSpecialGoodsVC *gvc = [GYSpecialGoodsVC new];
            gvc.navTitle = @"专区直营";
            [self.navigationController pushViewController:gvc animated:YES];
        }else if (indexPath.item == 1) {
            GYSpecialGoodsVC *gvc = [GYSpecialGoodsVC new];
            gvc.navTitle = @"积压甩卖";
            [self.navigationController pushViewController:gvc animated:YES];
        }else if (indexPath.item == 2) {
            GYCategoryVC *cvc = [GYCategoryVC  new];
            cvc.selectIndex = 0;
            [self.navigationController pushViewController:cvc animated:YES];
        }else if (indexPath.item == 3) {
            GYCategoryVC *cvc = [GYCategoryVC  new];
            cvc.selectIndex = 1;
            [self.navigationController pushViewController:cvc animated:YES];
        }else if (indexPath.item == 4) {
            GYPublishWorkVC *wvc = [GYPublishWorkVC new];
            [self.navigationController pushViewController:wvc animated:YES];
        }else{
            
        }
    }else{//推荐商品分组
        GYGoodsDetailVC *dvc = [GYGoodsDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        CGFloat width = (HX_SCREEN_WIDTH-30*2.0-50*2.0)/3.0;
        CGFloat height = width+30.f;
        return CGSizeMake(width, height);
    }else if (indexPath.section == 1) {//推荐商品分组
        CGFloat width = (HX_SCREEN_WIDTH-10*3)/2.0;
        CGFloat height = width*3/4.0+90.f;
        return CGSizeMake(width, height);
    }else{//推荐商品分组
        CGFloat width = (HX_SCREEN_WIDTH-10*3)/2.0;
        CGFloat height = width*3/4.0+90.f;
        return CGSizeMake(width, height);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {//分类
        return 5.f;
    }else if (section == 1) {//推荐商品分组
        return 5.f;
    }else{//推荐商品分组
        return 5.f;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {//分类
        return 50.f;
    }else if (section == 1) {//推荐商品分组
        return 5.f;
    }else{//推荐商品分组
        return 5.f;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {//分类
        return  UIEdgeInsetsMake(10.f, 30.f, 10.f, 30.f);
    }else if (section == 1) {//推荐商品分组
        return  UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
    }else{//推荐商品分组
        return  UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
    }
}
@end
