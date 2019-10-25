//
//  GYSpecialGoodsVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYSpecialGoodsVC.h"
#import "GYSpecialGoodsCell.h"
#import "GYGoodsDetailVC.h"
#import "GYCateMenuView.h"
#import "GYBrandMenuView.h"
#import "GYGoodsCate.h"
#import "GYBrand.h"
#import "GYSeries.h"
#import "GYGoods.h"

static NSString *const SpecialGoodsCell = @"SpecialGoodsCell";
@interface GYSpecialGoodsVC ()<UITableViewDelegate,UITableViewDataSource,GYCateMenuViewDelegate,GYBrandMenuViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *cateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cateImg;
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seriesImg;
@property (weak, nonatomic) IBOutlet UILabel *seriesLabel;
/* 选中的品牌或者系列 */
@property(nonatomic,strong) UIButton *selectBtn;
/** 分类 */
@property (nonatomic,strong) GYCateMenuView *cateView;
/** 品牌 */
@property (nonatomic,strong) GYBrandMenuView *brandView;
/** 系列 */
@property (nonatomic,strong) GYBrandMenuView *sericesView;
/** 分类数据 */
@property(nonatomic,strong) NSArray *goodsCates;
/** 分类id */
@property(nonatomic,copy) NSString *cate_id;
/** 品牌数据 */
@property(nonatomic,strong) NSArray *brands;
/** 品牌id */
@property(nonatomic,copy) NSString *brand_id;
/** 系列数据 */
@property(nonatomic,strong) NSArray *series;
/** 系列id */
@property(nonatomic,copy) NSString *series_id;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 商品列表 */
@property(nonatomic,strong) NSMutableArray *goodsData;
@end

@implementation GYSpecialGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.navTitle];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getFilterDataRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)setCate_id:(NSString *)cate_id
{
    if (![_cate_id isEqualToString:cate_id]) {
        _cate_id = cate_id;
        hx_weakify(self);
        [self getSpecialGoodsDataRequest:YES completedCall:^{
            hx_strongify(weakSelf);
            [strongSelf.tableView reloadData];
        }];
    }
}
-(void)setBrand_id:(NSString *)brand_id
{
    if (![_brand_id isEqualToString:brand_id]) {
        _brand_id = brand_id;
        hx_weakify(self);
        [self getSpecialGoodsDataRequest:YES completedCall:^{
            hx_strongify(weakSelf);
            [strongSelf.tableView reloadData];
        }];
    }
}
-(void)setSeries_id:(NSString *)series_id
{
    if (![_series_id isEqualToString:series_id]) {
        _series_id = series_id;
        hx_weakify(self);
        [self getSpecialGoodsDataRequest:YES completedCall:^{
            hx_strongify(weakSelf);
            [strongSelf.tableView reloadData];
        }];
    }
}
-(GYCateMenuView *)cateView
{
    if (_cateView == nil) {
        _cateView = [[GYCateMenuView alloc] init];
        _cateView.delegate = self;
        _cateView.titleColor = UIColorFromRGB(0x131D2D);
        _cateView.titleHightLightColor = HXControlBg;
    }
    return _cateView;
}
-(GYBrandMenuView *)brandView
{
    if (_brandView == nil) {
        _brandView = [[GYBrandMenuView alloc] init];
        _brandView.delegate = self;
        _brandView.titleColor = UIColorFromRGB(0x131D2D);
        _brandView.titleHightLightColor = HXControlBg;
    }
    return _brandView;
}
-(GYBrandMenuView *)sericesView
{
    if (_sericesView == nil) {
        _sericesView = [[GYBrandMenuView alloc] init];
        _sericesView.delegate = self;
        _sericesView.titleColor = UIColorFromRGB(0x131D2D);
        _sericesView.titleHightLightColor = HXControlBg;
    }
    return _sericesView;
}
-(NSMutableArray *)goodsData
{
    if (_goodsData == nil) {
        _goodsData = [NSMutableArray array];
    }
    return _goodsData;
}
#pragma mark -- 视图相关
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSpecialGoodsCell class]) bundle:nil] forCellReuseIdentifier:SpecialGoodsCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getSpecialGoodsDataRequest:YES completedCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getSpecialGoodsDataRequest:NO completedCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
}
#pragma mark -- 数据请求
-(void)getFilterDataRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [HXNetworkTool POST:HXRC_M_URL action:@"getCategoryData" parameters:@{} success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] boolValue]) {
                strongSelf.goodsCates = [NSArray yy_modelArrayWithClass:[GYGoodsCate class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [HXNetworkTool POST:HXRC_M_URL action:@"getBrandData" parameters:@{} success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] boolValue]) {
                strongSelf.brands = [NSArray yy_modelArrayWithClass:[GYBrand class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序3
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [HXNetworkTool POST:HXRC_M_URL action:@"getGoodSeries" parameters:@{} success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] boolValue]) {
                strongSelf.series = [NSArray yy_modelArrayWithClass:[GYSeries class] json:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);

        }];
    });
    // 执行循序4
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getSpecialGoodsDataRequest:YES completedCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序8
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        // 执行顺序10
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            hx_strongify(weakSelf);
            [strongSelf stopShimmer];
            strongSelf.tableView.hidden = NO;
            [strongSelf.tableView reloadData];
            
        });
    });
}
-(void)getSpecialGoodsDataRequest:(BOOL)isRefresh completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"cate_id"] = (self.cate_id && self.cate_id.length)?self.cate_id:@"";//根据分类筛选
    parameters[@"brand_id"] = (self.brand_id && self.brand_id.length)?self.brand_id:@"";//根据品牌筛选
    parameters[@"series_id"] = (self.series_id && self.series_id.length)?self.series_id:@"";//根据系列筛选
    
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:(self.dataType==1)?@"getDirectGoodData":@"getStockData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;

                [strongSelf.goodsData removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYGoods class] json:responseObject[@"data"]];
                [strongSelf.goodsData addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;

                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYGoods class] json:responseObject[@"data"]];
                    [strongSelf.goodsData addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
        if (completedCall) {
            completedCall();
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completedCall) {
            completedCall();
        }
    }];
}
#pragma mark -- 点击事件
- (IBAction)cateBtnClicked:(UIButton *)sender {
    if (self.brandView.show) {
        [self.brandView menuHidden];
    }
    if (self.sericesView.show) {
        [self.sericesView menuHidden];
    }
    
    if (self.cateView.show) {
        [self.cateView menuHidden];
        return;
    }
    self.selectBtn = nil;
    
    self.cateView.dataType = 1;
    self.cateView.dataSource = self.goodsCates;
    self.cateView.transformImageView = self.cateImg;
    self.cateView.titleLabel = self.cateLabel;
    
    [self.cateView menuShowInSuperView:self.view];
}
- (IBAction)brandBtnClicked:(UIButton *)sender {
    if (self.cateView.show) {
        [self.cateView menuHidden];
    }
    if (self.sericesView.show) {
        [self.sericesView menuHidden];
    }
    
    if (self.brandView.show) {
        [self.brandView menuHidden];
        return;
    }
    self.selectBtn = sender;

    self.brandView.dataType = 1;
    self.brandView.dataSource = self.brands;
    self.brandView.transformImageView = self.brandImg;
    self.brandView.titleLabel = self.brandLabel;
    
    [self.brandView menuShowInSuperView:self.view];
}
- (IBAction)seriesBtnClicked:(UIButton *)sender {
    if (self.cateView.show) {
        [self.cateView menuHidden];
    }
    if (self.brandView.show) {
        [self.brandView menuHidden];
    }
    
    if (self.sericesView.show) {
        [self.sericesView menuHidden];
        return;
    }
    self.selectBtn = sender;
    
    self.sericesView.dataType = 2;
    self.sericesView.dataSource = self.series;
    self.sericesView.transformImageView = self.seriesImg;
    self.sericesView.titleLabel = self.seriesLabel;
    
    [self.sericesView menuShowInSuperView:self.view];
}
#pragma mark -- GYCateMenuViewDelegate
//出现位置
- (CGPoint)cateMenu_positionInSuperView
{
    return CGPointMake(0, 44);
}
//点击事件
- (void)cateMenu:(GYCateMenuView *)menu  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYGoodsCate *cate = self.goodsCates[menu.selectIndex];
    GYGoodsSubCate *subCate = cate.sub[indexPath.item];
    self.cate_id = subCate.cate_id;
}
#pragma mark -- GYBrandMenuViewDelegate
//出现位置
- (CGPoint)brandMenu_positionInSuperView
{
    return CGPointMake(0, 44);
}
//点击事件
- (void)brandMenu:(GYBrandMenuView *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (menu.dataType == 1) {
        GYBrand *brand = self.brands[indexPath.item];
        self.brand_id = brand.brand_id;
    }else{
        GYSeries *series = self.series[indexPath.item];
        self.series_id = series.series_id;
    }
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYSpecialGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:SpecialGoodsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GYGoods *goods = self.goodsData[indexPath.row];
    cell.goods = goods;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 100.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYGoods *goods = self.goodsData[indexPath.row];
    GYGoodsDetailVC *dvc = [GYGoodsDetailVC new];
    dvc.goods_id = goods.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
