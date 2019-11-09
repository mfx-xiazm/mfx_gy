//
//  GYSearchGoodsVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYSearchGoodsVC.h"
#import "GYSpecialGoodsCell.h"
#import "GYGoodsDetailVC.h"
#import "GYGoods.h"
#import "HXSearchBar.h"

static NSString *const SpecialGoodsCell = @"SpecialGoodsCell";
@interface GYSearchGoodsVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 商品列表 */
@property(nonatomic,strong) NSMutableArray *goodsData;
@property (weak, nonatomic) IBOutlet UILabel *shelfTimeLabel;
/* 按照商品上架时间排序 1升序2降序*/
@property(nonatomic,copy) NSString *shelfTime;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *priceImg;
/* 按照商品价格排序 1升序2降序 */
@property(nonatomic,copy) NSString *price;
@end

@implementation GYSearchGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getGoodsDataRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)goodsData
{
    if (_goodsData == nil) {
        _goodsData = [NSMutableArray array];
    }
    return _goodsData;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH - 70.f, 30.f)];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 6;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.text = self.keyword;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
}
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
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getGoodsDataRequest:YES];
    }];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getGoodsDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getGoodsDataRequest:NO];
    }];
}
#pragma mark -- 点击
- (IBAction)shelfTimeClicked:(UIButton *)sender {
    self.priceLabel.textColor = [UIColor blackColor];
    self.priceImg.image = HXGetImage(@"上下");
    self.price = @"";
    
    self.shelfTimeLabel.textColor = HXControlBg;
    self.shelfTime = @"2";
    
    [self getGoodsDataRequest:YES];
}
- (IBAction)priceClicked:(UIButton *)sender {
    self.shelfTimeLabel.textColor = [UIColor blackColor];
    self.shelfTime = @"";
    
    self.priceLabel.textColor = HXControlBg;
    if ([self.price isEqualToString:@"2"]) {//2降序
        self.priceImg.image = HXGetImage(@"筛选上拉");
        self.price = @"1";//1升序
    }else{//1升序
        self.priceImg.image = HXGetImage(@"筛选下拉");
        self.price = @"2";//2降序
    }
    
    [self getGoodsDataRequest:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.keyword = [textField hasText]?textField.text:@"";
    [self getGoodsDataRequest:YES];
    return YES;
}
#pragma mark -- 接口请求
-(void)getGoodsDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_name"] = self.keyword;//关键词
    parameters[@"shelf_time"] = (self.shelfTime && self.shelfTime.length)?self.shelfTime:@"";//按照商品上架时间排序 1升序2降序
    parameters[@"price"] = (self.price && self.price.length)?self.price:@"";//按照商品价格排序 1升序2降序
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"searchGoodsData" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf.tableView reloadData];
            });
        }else{
            strongSelf.tableView.zx_emptyContentView.zx_type = GYUIApiErrorState;
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        strongSelf.tableView.zx_emptyContentView.zx_type = GYUINetErrorState;
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
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
