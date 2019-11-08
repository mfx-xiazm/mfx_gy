//
//  GYMessageVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMessageVC.h"
#import "GYMessageCell.h"
#import "GYMessage.h"
#import "GYOrderDetailVC.h"
#import "GYMyNeedsDetailVC.h"

static NSString *const MessageCell = @"MessageCell";
@interface GYMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 消息列表 */
@property(nonatomic,strong) NSArray *msgs;
@end

@implementation GYMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"消息"];
    [self setUpTableView];
    [self startShimmer];
    [self getMessageDataRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYMessageCell class]) bundle:nil] forCellReuseIdentifier:MessageCell];
}
#pragma mark -- 数据请求
-(void)getMessageDataRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getMessageData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.msgs = [NSArray yy_modelArrayWithClass:[GYMessage class] json:responseObject[@"data"]];
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
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)readMsgRequest:(NSString *)msg_id
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"msg_id"] = msg_id;
    [HXNetworkTool POST:HXRC_M_URL action:@"readMsg" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GYMessage *msg = self.msgs[indexPath.row];
    cell.msg = msg;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYMessage *msg = self.msgs[indexPath.row];
    if (!msg.is_read) {
        msg.is_read = YES;
        [self readMsgRequest:msg.msg_id];
    }
    [tableView reloadData];
    /** 1订单详情 2发布需求接单详情 3退款订单详情 */
    if ([msg.ref_type isEqualToString:@"1"]) {
        GYOrderDetailVC *dvc = [GYOrderDetailVC new];
        dvc.oid = msg.ref_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }else if ([msg.ref_type isEqualToString:@"2"]) {
        GYMyNeedsDetailVC *dvc = [GYMyNeedsDetailVC new];
        dvc.task_id = msg.ref_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }else{
        GYOrderDetailVC *dvc = [GYOrderDetailVC new];
        dvc.refund_id = msg.ref_id;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

@end
