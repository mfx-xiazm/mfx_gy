//
//  GYMyWorksVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyWorksVC.h"
#import "GYMyNeedsCell.h"
#import "GYMyNeedsDetailVC.h"
#import "GYMyTasks.h"

static NSString *const MyNeedsCell = @"MyNeedsCell";
@interface GYMyWorksVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 需求列表 */
@property(nonatomic,strong) NSMutableArray *tasks;
@end

@implementation GYMyWorksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的接单"];
    [self setUpTableView];
    [self startShimmer];
    [self setUpRefresh];
    [self getTasksDataRequest:YES];
}
-(NSMutableArray *)tasks
{
    if (_tasks == nil) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYMyNeedsCell class]) bundle:nil] forCellReuseIdentifier:MyNeedsCell];
    
    hx_weakify(self);
    [self.tableView zx_setEmptyView:[GYEmptyView class] isFull:YES clickedBlock:^(UIButton * _Nullable btn) {
        [weakSelf startShimmer];
        [weakSelf getTasksDataRequest:YES];
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
        [strongSelf getTasksDataRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getTasksDataRequest:NO];
    }];
}
#pragma mark -- 数据请求
-(void)getTasksDataRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getTaskReceive" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.tasks removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYMyTasks class] json:responseObject[@"data"]];
                [strongSelf.tasks addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYMyTasks class] json:responseObject[@"data"]];
                    [strongSelf.tasks addObjectsFromArray:arrt];
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
    return self.tasks.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYMyNeedsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyNeedsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GYMyTasks *task = self.tasks[indexPath.row];
    cell.task = task;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 185.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYMyNeedsDetailVC *dvc = [GYMyNeedsDetailVC new];
    GYMyTasks *task = self.tasks[indexPath.row];
    dvc.task_id = task.task_id;
    dvc.isTaked = YES;
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
