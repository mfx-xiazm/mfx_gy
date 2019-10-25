//
//  GYMyCollentVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyCollentVC.h"
#import "GYMyCollectCell.h"
#import "GYGoodsDetailVC.h"
#import "GYMyCollect.h"
#import "zhAlertView.h"
#import <zhPopupController.h>

static NSString *const MyCollectCell = @"MyCollectCell";
@interface GYMyCollentVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *handleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
/* 编辑 */
@property(nonatomic,strong) UIButton *editBtn;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 收藏列表 */
@property(nonatomic,strong) NSMutableArray *collects;
@end

@implementation GYMyCollentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    self.handleView.hidden = YES;
    self.handleViewHeight.constant = 0.f;
    
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getMyCollectRequest:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)collects
{
    if (_collects == nil) {
        _collects = [NSMutableArray array];
    }
    return _collects;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"我的收藏"];

    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    edit.hxn_size = CGSizeMake(50, 40);
    edit.titleLabel.font = [UIFont systemFontOfSize:13];
    [edit setTitle:@"编辑" forState:UIControlStateNormal];
    [edit setTitle:@"完成" forState:UIControlStateSelected];
    [edit addTarget:self action:@selector(editClicked) forControlEvents:UIControlEventTouchUpInside];
    [edit setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    self.editBtn = edit;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:edit];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYMyCollectCell class]) bundle:nil] forCellReuseIdentifier:MyCollectCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getMyCollectRequest:YES];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getMyCollectRequest:NO];
    }];
}
#pragma mark -- 数据请求
-(void)getMyCollectRequest:(BOOL)isRefresh
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getCollectList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.collects removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYMyCollect class] json:responseObject[@"data"]];
                [strongSelf.collects addObjectsFromArray:arrt];
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYMyCollect class] json:responseObject[@"data"]];
                    [strongSelf.collects addObjectsFromArray:arrt];
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 业务逻辑
/**
 判断是否全选
 */
-(void)checkIsAllSelect
{
    __block BOOL isAllSelect = YES;
    [self.collects enumerateObjectsUsingBlock:^(GYMyCollect * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isSelect) {
            isAllSelect = NO;
            *stop = YES;
        }
    }];
    self.selectAllBtn.selected = isAllSelect;
}
/**
 检查是否有选中的商品
 
 @return Yes存在选中/No不存在选中
 */
-(BOOL)checkIsHaveSelect
{
    __block BOOL isHaveSelect = NO;
    [self.collects enumerateObjectsUsingBlock:^(GYMyCollect * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) {
            isHaveSelect = YES;
            *stop = YES;
        }
    }];
    return isHaveSelect;
}
-(void)delCollectRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSMutableString *collect_ids = [NSMutableString string];
    [self.collects enumerateObjectsUsingBlock:^(GYMyCollect * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) {
            [collect_ids appendFormat:@"%@",collect_ids.length?[NSString stringWithFormat:@",%@",obj.collect_id]:[NSString stringWithFormat:@"%@",obj.collect_id]];
        }
    }];
    parameters[@"collect_ids"] = collect_ids;//删除多个id间用逗号隔开
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"delCollects" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:strongSelf.collects];
            [tempArr enumerateObjectsUsingBlock:^(GYMyCollect * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isSelect) {
                    [strongSelf.collects removeObject:obj];
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf checkIsAllSelect];
                [strongSelf.tableView reloadData];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 点击事件
-(void)editClicked
{
    self.editBtn.selected = !self.editBtn.isSelected;
    if (self.editBtn.isSelected) {
        self.handleView.hidden = NO;
        self.handleViewHeight.constant = 44.f;
    }else{
        self.handleView.hidden = YES;
        self.handleViewHeight.constant = 0.f;
    }
    [self.tableView reloadData];
}
- (IBAction)selectAllClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.isSelected) {
        [self.collects enumerateObjectsUsingBlock:^(GYMyCollect * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelect = 1;
        }];
    }else{
        [self.collects enumerateObjectsUsingBlock:^(GYMyCollect * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelect = 0;
        }];
    }
    [self.tableView reloadData];
}
- (IBAction)delCollectClicked:(UIButton *)sender {
    if (![self checkIsHaveSelect]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择商品"];
        return;
    }
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除选中商品吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
    hx_weakify(self);
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
        [strongSelf delCollectRequest];
    }];
    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYMyCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCollectCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goodsView.hidden = self.editBtn.isSelected;
    cell.editView.hidden = !self.editBtn.isSelected;
    GYMyCollect *collect = self.collects[indexPath.row];
    cell.collect = collect;
    hx_weakify(self);
    cell.selectCollectCall = ^{
        hx_strongify(weakSelf);
        [strongSelf checkIsAllSelect];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 100.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYMyCollect *collect = self.collects[indexPath.row];
    GYGoodsDetailVC *dvc = [GYGoodsDetailVC new];
    dvc.goods_id = collect.goods_id;
    [self.navigationController pushViewController:dvc animated:YES];
}



@end
