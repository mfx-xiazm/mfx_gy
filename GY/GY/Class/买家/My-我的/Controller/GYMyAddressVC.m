//
//  GYMyAddressVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyAddressVC.h"
#import "GYMyAddressCell.h"
#import "GYEditAddressVC.h"
#import "GYConfirmOrder.h"

static NSString *const MyAddressCell = @"MyAddressCell";
@interface GYMyAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 数组 */
@property (nonatomic,strong) NSMutableArray *addressList;
@end

@implementation GYMyAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的地址"];
    [self setUpTableView];
    [self startShimmer];
    [self getAddressListRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(NSMutableArray *)addressList
{
    if (_addressList == nil) {
        _addressList = [NSMutableArray array];
    }
    return _addressList;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYMyAddressCell class]) bundle:nil] forCellReuseIdentifier:MyAddressCell];
}
#pragma mark -- 接口请求
-(void)getAddressListRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getAddressList" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [strongSelf.addressList removeAllObjects];
            NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYConfirmAddress class] json:responseObject[@"data"]];
            [strongSelf.addressList addObjectsFromArray:arrt];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新界面
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
#pragma mark -- 点击事件
- (IBAction)addAddressClicked:(UIButton *)sender {
    GYEditAddressVC *avc = [GYEditAddressVC new];
    hx_weakify(self);
    avc.editSuccessCall = ^(NSInteger type) {
        hx_strongify(weakSelf);
        // 1新增 2编辑 3删除
        [strongSelf getAddressListRequest];
    };
    [self.navigationController pushViewController:avc animated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYMyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:MyAddressCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GYConfirmAddress *address = self.addressList[indexPath.row];
    cell.address = address;
    hx_weakify(self);
    cell.editClickedCall = ^{
        hx_strongify(weakSelf);
        GYEditAddressVC *avc = [GYEditAddressVC new];
        avc.address = address;
        avc.editSuccessCall = ^(NSInteger type) {
            // 1新增 2编辑 3删除
            if (type == 3) {
                [strongSelf.addressList removeObjectAtIndex:indexPath.row];
                [tableView reloadData];
            }else{
                [strongSelf getAddressListRequest];
            }
        };
        [strongSelf.navigationController pushViewController:avc animated:YES];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 65.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYConfirmAddress *address = self.addressList[indexPath.row];
    if (self.getAddressCall) {
        self.getAddressCall(address);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
