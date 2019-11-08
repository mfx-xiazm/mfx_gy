//
//  GYCategoryChildVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYCategoryChildVC.h"
#import "GYBigCateCell.h"
#import "GYSmallCateCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GYSmallCateHeaderView.h"
#import "GYCateGoodsVC.h"
#import "GYGoodsCate.h"

static NSString *const BigCateCell = @"BigCateCell";
static NSString *const SmallCateCell = @"SmallCateCell";
static NSString *const SmallCateHeaderView = @"SmallCateHeaderView";

@interface GYCategoryChildVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
/** 左边tableView */
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
/** 右边collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;
/** 分类数据 */
@property(nonatomic,strong) NSArray *goodsCates;
/** 左边的选择的索引 */
@property(nonatomic,assign) NSInteger selectIndex;
@end

@implementation GYCategoryChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpCollectionView];
    [self startShimmer];
    [self getCategoryDataRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
}
#pragma mark -- 页面设置
/** 页面设置 */
-(void)setUpTableView
{
    _leftTableView.backgroundColor = HXGlobalBg;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.rowHeight = 44.f;
    _leftTableView.tableFooterView = [UIView new];
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _leftTableView.estimatedSectionHeaderHeight = 0;
    _leftTableView.estimatedSectionFooterHeight = 0;
    [_leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYBigCateCell class]) bundle:nil] forCellReuseIdentifier:BigCateCell];
    
    _leftTableView.hidden = YES;
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = YES;
    self.rightCollectionView.collectionViewLayout = flowLayout;
    self.rightCollectionView.dataSource = self;
    self.rightCollectionView.delegate = self;
    self.rightCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.rightCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSmallCateCell class]) bundle:nil] forCellWithReuseIdentifier:SmallCateCell];
    [self.rightCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSmallCateHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SmallCateHeaderView];
    
    _rightCollectionView.hidden = YES;
}
#pragma mark -- 数据请求
-(void)getCategoryDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getCategoryData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.goodsCates = [NSArray yy_modelArrayWithClass:[GYGoodsCate class] json:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.leftTableView.hidden = NO;
                strongSelf.rightCollectionView.hidden = NO;
                [strongSelf.leftTableView reloadData];
                [strongSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [strongSelf.rightCollectionView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView 数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsCates.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYBigCateCell *cell = [tableView dequeueReusableCellWithIdentifier:BigCateCell forIndexPath:indexPath];
    GYGoodsCate *cate = self.goodsCates[indexPath.row];
    cell.cate = cate;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.row;
    [self.rightCollectionView reloadData];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    GYGoodsCate *cate = self.goodsCates[self.selectIndex];
    return cate.sub.count;
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
    GYGoodsCate *cate = self.goodsCates[self.selectIndex];
    GYGoodsSubCate *subCate = cate.sub[indexPath.item];
    cell.subCate = subCate;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GYGoodsCate *cate = self.goodsCates[self.selectIndex];
    GYGoodsSubCate *subCate = cate.sub[indexPath.item];
    
    GYCateGoodsVC *gvc = [GYCateGoodsVC new];
    gvc.navTitle = subCate.cate_name;
    gvc.cate_id = subCate.cate_id;
    gvc.dataType = 1; 
    [self.navigationController pushViewController:gvc animated:YES];
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
        GYGoodsCate *cate = self.goodsCates[self.selectIndex];
        headerView.cateName.text = cate.cate_name;
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 44);
}

@end
