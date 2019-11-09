//
//  GYAfterSaleVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYAfterSaleVC.h"
#import "GYMyOrderCell.h"
#import "GYMyOrderHeader.h"
#import "GYMyOrderFooter.h"
#import "GYMyRefund.h"
#import "GYOrderDetailVC.h"

static NSString *const MyOrderCell = @"MyOrderCell";
@interface GYAfterSaleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 退款列表 */
@property(nonatomic,strong) NSMutableArray *refunds;
@end

@implementation GYAfterSaleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"售后退款"];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getRefundListRequest:YES];
}
-(NSMutableArray *)refunds
{
    if (_refunds == nil) {
        _refunds = [NSMutableArray array];
    }
    return _refunds;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)setUpTableView
{
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYMyOrderCell class]) bundle:nil] forCellReuseIdentifier:MyOrderCell];
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getRefundListRequest:YES];
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
        [strongSelf getRefundListRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getRefundListRequest:NO];
    }];
}
#pragma mark -- 数据请求
-(void)getRefundListRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"orderRefundList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.refunds removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYMyRefund class] json:responseObject[@"data"]];
                [strongSelf.refunds addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYMyRefund class] json:responseObject[@"data"]];
                    [strongSelf.refunds addObjectsFromArray:arrt];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.refunds.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GYMyRefund *refund = self.refunds[indexPath.section];
    cell.refund = refund;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 115.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GYMyOrderHeader *header = [GYMyOrderHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    GYMyRefund *refund = self.refunds[section];
    header.refund = refund;
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GYMyOrderFooter *footer = [GYMyOrderFooter loadXibView];
    footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 40.f);
    footer.handleView.hidden = YES;
    GYMyRefund *refund = self.refunds[section];
    footer.refund = refund;
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYOrderDetailVC *dvc = [GYOrderDetailVC new];
    GYMyRefund *refund = self.refunds[indexPath.section];
    dvc.refund_id = refund.refund_id;
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
