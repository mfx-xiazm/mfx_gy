//
//  GYBrandChildVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYBrandChildVC.h"
#import "GYBrandCateCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GYCateGoodsVC.h"
#import "GYBrand.h"

static NSString *const BrandCateCell = @"BrandCateCell";

@interface GYBrandChildVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
/** collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 品牌数据 */
@property(nonatomic,strong) NSArray *brands;
@end

@implementation GYBrandChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollectionView];
    [self startShimmer];
    [self getBrandDataRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
}
#pragma mark -- 页面设置
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = YES;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYBrandCateCell class]) bundle:nil] forCellWithReuseIdentifier:BrandCateCell];
}
-(void)getBrandDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getBrandData" parameters:@{@"not_page":@"1"} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.brands = [NSArray yy_modelArrayWithClass:[GYBrand class] json:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.collectionView.hidden = NO;
            [strongSelf.collectionView reloadData];
        });
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.brands.count;
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
    GYBrand *brand = self.brands[indexPath.item];
    cell.brand = brand;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GYBrand *brand = self.brands[indexPath.item];
    GYCateGoodsVC *gvc = [GYCateGoodsVC new];
    gvc.navTitle = brand.brand_name;
    gvc.brand_id = brand.brand_id;
    gvc.dataType = 2;
    [self.navigationController pushViewController:gvc animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.hxn_width - 10*4.0)/3.0;
    CGFloat height = 65.f;
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

@end
