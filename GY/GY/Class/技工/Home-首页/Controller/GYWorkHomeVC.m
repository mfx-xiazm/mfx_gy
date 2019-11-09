//
//  GYWorkHomeVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYWorkHomeVC.h"
#import "GYMyNeedsCell.h"
#import "GYMyNeedsDetailVC.h"
#import "GYBrandMenuView.h"
#import "GYCateMenuView.h"
#import "GYMyTasks.h"
#import "GYWorkType.h"
#import "GYRegion.h"

static NSString *const MyNeedsCell = @"MyNeedsCell";
@interface GYWorkHomeVC ()<UITableViewDelegate,UITableViewDataSource,GYCateMenuViewDelegate,GYBrandMenuViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *regionImg;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *needImg;
@property (weak, nonatomic) IBOutlet UILabel *needLabel;
/** 地区 */
@property (nonatomic,strong) GYCateMenuView *regionView;
/** 需求类型 */
@property (nonatomic,strong) GYBrandMenuView *needTypeView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 需求列表 */
@property(nonatomic,strong) NSMutableArray *tasks;
/* 技术工种 */
@property(nonatomic,strong) NSArray *workTypes;
/* 地区 */
@property(nonatomic,strong) NSArray *districts;
/* 需求工种id */
@property(nonatomic,copy) NSString *workTypeId;
/* 城市id */
@property(nonatomic,copy) NSString *cityId;
@end

@implementation GYWorkHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self startShimmer];
    [self setUpRefresh];
    [self getWorkerHomeData];
}
-(NSMutableArray *)tasks
{
    if (_tasks == nil) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}
-(void)setWorkTypeId:(NSString *)workTypeId
{
    if (![_workTypeId isEqualToString:workTypeId]) {
        _workTypeId = workTypeId;
        hx_weakify(self);
        [self getTasksDataRequest:YES completedCall:^{
            hx_strongify(weakSelf);
            [strongSelf.tableView reloadData];
        }];
    }
}
-(void)setCityId:(NSString *)cityId
{
    if (![_cityId isEqualToString:cityId]) {
        _cityId = cityId;
        hx_weakify(self);
        [self getTasksDataRequest:YES completedCall:^{
            hx_strongify(weakSelf);
            [strongSelf.tableView reloadData];
        }];
    }
}
-(GYCateMenuView *)regionView
{
    if (_regionView == nil) {
        _regionView = [[GYCateMenuView alloc] init];
        _regionView.delegate = self;
        _regionView.titleColor = UIColorFromRGB(0x131D2D);
        _regionView.titleHightLightColor = HXControlBg;
    }
    return _regionView;
}
-(GYBrandMenuView *)needTypeView
{
    if (_needTypeView == nil) {
        _needTypeView = [[GYBrandMenuView alloc] init];
        _needTypeView.delegate = self;
        _needTypeView.titleColor = UIColorFromRGB(0x131D2D);
        _needTypeView.titleHightLightColor = HXControlBg;
    }
    return _needTypeView;
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
        [weakSelf getTasksDataRequest:YES completedCall:^{
            [weakSelf.tableView reloadData];
        }];
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
        [strongSelf getTasksDataRequest:YES completedCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getTasksDataRequest:NO completedCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
}
#pragma mark -- 数据请求
-(void)getWorkerHomeData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    if (districtStr == nil) {
        return ;
    }
    NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *district = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYRegion class] json:district[@"result"][@"list"]];
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:arrt];
    GYRegion *all = [[GYRegion alloc] init];
    all.cityid = @"";
    all.alias = @"全部地区";
    
    GYSubRegion *sub = [[GYSubRegion alloc] init];
    sub.cityid = @"";
    sub.alias = @"全部地区";
    all.city = @[sub];
    [tempArr insertObject:all atIndex:0];
    
    self.districts = [NSArray arrayWithArray:tempArr];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [HXNetworkTool POST:HXRC_M_URL action:@"getWorkTypeData" parameters:@{} success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] integerValue] == 1) {
                NSArray *arrt1 = [NSArray yy_modelArrayWithClass:[GYWorkType class] json:responseObject[@"data"]];
                
                NSMutableArray *tempArr1 = [NSMutableArray arrayWithArray:arrt1];
                GYWorkType *all = [[GYWorkType alloc] init];
                all.set_id = @"";
                all.set_val = @"全部类型";
                [tempArr1 insertObject:all atIndex:0];
                
                strongSelf.workTypes = [NSArray arrayWithArray:tempArr1];
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
        [strongSelf getTasksDataRequest:YES completedCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
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
-(void)getTasksDataRequest:(BOOL)isRefresh completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"city_ids"] = (self.cityId && self.cityId.length)?self.cityId:@"";//多个城市id间用逗号隔开
    parameters[@"type_ids"] = (self.workTypeId && self.workTypeId.length)?self.workTypeId:@"";//多个工种id间用逗号隔开
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getWorkerData" parameters:parameters success:^(id responseObject) {
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
            if (completedCall) {
                completedCall();
            }
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
        if (completedCall) {
            completedCall();
        }
    }];
}
#pragma mark -- 点击事件
- (IBAction)regionBtnClicked:(UIButton *)sender {
    
    if (self.needTypeView.show) {
        [self.needTypeView menuHidden];
    }
    
    if (self.regionView.show) {
        [self.regionView menuHidden];
        return;
    }
    
    self.regionView.dataType = 2;
    self.regionView.dataSource = self.districts;
    self.regionView.transformImageView = self.regionImg;
    self.regionView.titleLabel = self.regionLabel;
    
    [self.regionView menuShowInSuperView:nil];
}
- (IBAction)needBtnClicked:(UIButton *)sender {
    
    if (self.regionView.show) {
        [self.regionView menuHidden];
    }
    
    if (self.needTypeView.show) {
        [self.needTypeView menuHidden];
        return;
    }
    
    self.needTypeView.dataType = 3;
    self.needTypeView.dataSource = self.workTypes;
    self.needTypeView.transformImageView = self.needImg;
    self.needTypeView.titleLabel = self.needLabel;
    
    [self.needTypeView menuShowInSuperView:nil];
}
#pragma mark -- GYCateMenuViewDelegate
//出现位置
- (CGPoint)cateMenu_positionInSuperView
{
    return CGPointMake(0, self.HXNavBarHeight+44.f);
}
//点击事件
- (void)cateMenu:(GYCateMenuView *)menu  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYRegion *region = self.districts[menu.selectIndex];
    self.cityId = region.selectRegion.cityid;
}
#pragma mark -- GYBrandMenuViewDelegate
//出现位置
- (CGPoint)brandMenu_positionInSuperView
{
    return CGPointMake(0, self.HXNavBarHeight+44.f);
}
//点击事件
- (void)brandMenu:(GYBrandMenuView *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYWorkType *wordType = self.workTypes[indexPath.item];
    self.workTypeId = wordType.set_id;
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
    dvc.isToTake = YES;
    hx_weakify(self);
    dvc.rePublishCall = ^{
        hx_strongify(weakSelf);
        [strongSelf.tasks removeObject:task];
        [tableView reloadData];
    };
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
