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
#import "GYHomeData.h"
#import "GYWebContentVC.h"
#import "GYCateGoodsVC.h"
#import "GYLoginVC.h"
#import "HXNavigationController.h"
#import "UIView+WZLBadge.h"
#import "GYSearchGoodsVC.h"

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
/* 首页数据 */
@property(nonatomic,strong) GYHomeData *homeData;
@end

@implementation GYHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
    [self setUpRefresh];
    [self startShimmer];
    [self getHomeDataRequest];
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
    msg.badgeCenterOffset = CGPointMake(-10, 5);
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
    
    self.collectionView.hidden = YES;
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.collectionView.mj_footer resetNoMoreData];
        [strongSelf getHomeDataRequest];
    }];
}
#pragma mark -- 点击事件
-(void)msgClicked
{
    if ([MSUserManager sharedInstance].isLogined) {
        [self.msgBtn clearBadge];
        
        GYMessageVC *mvc = [GYMessageVC new];
        [self.navigationController pushViewController:mvc animated:YES];
    }else{
        HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:[GYLoginVC new]];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField hasText]) {
        GYSearchGoodsVC *gvc = [GYSearchGoodsVC new];
        gvc.keyword = textField.text;
        [self.navigationController pushViewController:gvc animated:YES];
        return YES;
    }else{
        return NO;
    }
}

#pragma mark -- 数据请求
-(void)getHomeDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getHomeData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.collectionView.mj_header endRefreshing];
        if([[responseObject objectForKey:@"status"] boolValue]) {
            strongSelf.homeData = [GYHomeData yy_modelWithDictionary:responseObject[@"data"]];
            NSArray *tempArr = @[@{@"cate_name":@"专区直营",@"image_name":@"专区直营"},
                                 @{@"cate_name":@"积压甩卖",@"image_name":@"积压甩卖"},
                                 @{@"cate_name":@"选型",@"image_name":@"选型"},
                                 @{@"cate_name":@"品牌",@"image_name":@"品牌"},
                                 @{@"cate_name":@"发单",@"image_name":@"发单"},
                                 @{@"cate_name":@"接单",@"image_name":@"接单"},
                                 ];
            strongSelf.homeData.homeTopCate = [NSArray yy_modelArrayWithClass:[GYHomeTopCate class] json:tempArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.collectionView.hidden = NO;
                if (strongSelf.homeData.homeunReadMsg) {
                    [strongSelf.msgBtn showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:WBadgeAnimTypeNone];
                }
                [strongSelf.collectionView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.collectionView.mj_header endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.homeData.homeCate.count + 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {//分类
        return self.homeData.homeTopCate.count;
    }else{//推荐商品分组
        GYHomeCate *cate = self.homeData.homeCate[section-1];
        return cate.goods.count;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    if (section == 0) {//分类
        return 3;
    }else{//推荐商品分组
        return 2;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        GYHomeCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCateCell forIndexPath:indexPath];
        GYHomeTopCate *topCate = self.homeData.homeTopCate[indexPath.item];
        cell.topCate = topCate;
        return cell;
    }else{//推荐商品分组
        GYShopGoodsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopGoodsCell forIndexPath:indexPath];
        GYHomeCate *cate = self.homeData.homeCate[indexPath.section-1];
        GYHomeCateGood *cateGood = cate.goods[indexPath.item];
        cell.cateGood = cateGood;
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
            header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH,HX_SCREEN_WIDTH*3/5+50.f+20.f);
            header.homeAdv = self.homeData.homeAdv;
            header.homeNotice = self.homeData.homeNotice;
            hx_weakify(self);
            header.bannerOrNoticeCall = ^(NSInteger type, NSInteger index) {
                hx_strongify(weakSelf);
                if (type == 1) {
                    GYHomeBanner *banner = strongSelf.homeData.homeAdv[index];
                    /** 1仅图片 2链接内容 3html富文本内容 4产品详情 */
                    if ([banner.adv_type isEqualToString:@"1"]) {
                        HXLog(@"仅图片");
                    }else if ([banner.adv_type isEqualToString:@"2"]) {
                        GYWebContentVC *cvc = [GYWebContentVC new];
                        cvc.navTitle = banner.adv_name;
                        cvc.isNeedRequest = NO;
                        cvc.url = banner.adv_content;
                        [strongSelf.navigationController pushViewController:cvc animated:YES];
                    }else if ([banner.adv_type isEqualToString:@"2"]) {
                        GYWebContentVC *cvc = [GYWebContentVC new];
                        cvc.navTitle = banner.adv_name;
                        cvc.isNeedRequest = NO;
                        cvc.htmlContent = banner.adv_content;
                        [strongSelf.navigationController pushViewController:cvc animated:YES];
                    }else{
                        GYGoodsDetailVC *dvc = [GYGoodsDetailVC new];
                        dvc.goods_id = banner.adv_content;
                        [strongSelf.navigationController pushViewController:dvc animated:YES];
                    }
                }else{
                    GYWebContentVC *cvc = [GYWebContentVC new];
                    cvc.navTitle = @"公告详情";
                    cvc.requestType = 2;
                    cvc.isNeedRequest = YES;
                    GYHomeNotice *ntice = strongSelf.homeData.homeNotice[index];
                    cvc.notice_id = ntice.notice_id;
                    [strongSelf.navigationController pushViewController:cvc animated:YES];
                }
            };
            return header;
        }else{
            GYHomeSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader forIndexPath:indexPath];
            GYHomeCate *cate = self.homeData.homeCate[indexPath.section-1];
            header.cate = cate;
            hx_weakify(self);
            header.sectionCateCall = ^{
                hx_strongify(weakSelf);
                GYCateGoodsVC *gvc = [GYCateGoodsVC new];
                gvc.navTitle = cate.cate_name;
                gvc.cate_id = cate.cate_id;
                gvc.dataType = 3;
                [strongSelf.navigationController pushViewController:gvc animated:YES];
            };
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
            gvc.dataType = 1;
            [self.navigationController pushViewController:gvc animated:YES];
        }else if (indexPath.item == 1) {
            GYSpecialGoodsVC *gvc = [GYSpecialGoodsVC new];
            gvc.navTitle = @"积压甩卖";
            gvc.dataType = 2;
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
            if ([MSUserManager sharedInstance].isLogined) {
                GYPublishWorkVC *wvc = [GYPublishWorkVC new];
                [self.navigationController pushViewController:wvc animated:YES];
            }else{
                HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:[GYLoginVC new]];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"暂无权限"];
        }
    }else{//推荐商品分组
        GYHomeCate *cate = self.homeData.homeCate[indexPath.section-1];
        GYHomeCateGood *cateGood = cate.goods[indexPath.item];
        GYGoodsDetailVC *dvc = [GYGoodsDetailVC new];
        dvc.goods_id = cateGood.goods_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//分类
        CGFloat width = (HX_SCREEN_WIDTH-30*2.0-50*2.0)/3.0;
        CGFloat height = width+30.f;
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
    }else{//推荐商品分组
        return 5.f;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {//分类
        return 50.f;
    }else{//推荐商品分组
        return 5.f;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {//分类
        return  UIEdgeInsetsMake(10.f, 30.f, 10.f, 30.f);
    }else{//推荐商品分组
        return  UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
    }
}
@end
