//
//  GYOrderDetailVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYOrderDetailVC.h"
#import "GYOrderDetailHeader.h"
#import "GYOrderDetailCell.h"
#import "GYOrderDetailFooter.h"
#import "GYInvoiceDetailFooter.h"
#import "GYEvaluateVC.h"

static NSString *const OrderDetailCell = @"OrderDetailCell";
@interface GYOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GYOrderDetailHeader *header;
/* 尾视图 */
@property(nonatomic,strong) GYInvoiceDetailFooter *footer;

@end

@implementation GYOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 225);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 280);
}
-(GYOrderDetailHeader *)header
{
    if (_header == nil) {
        _header = [GYOrderDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 225);
    }
    return _header;
}
-(GYInvoiceDetailFooter*)footer
{
    if (_footer == nil) {
        _footer = [GYInvoiceDetailFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 280);
    }
    return _footer;
}
-(void)setUpTableView
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 180.f;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYOrderDetailCell class]) bundle:nil] forCellReuseIdentifier:OrderDetailCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- 点击事件
- (IBAction)orderHandleBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        
    }else{
        GYEvaluateVC *evc = [GYEvaluateVC new];
        [self.navigationController pushViewController:evc animated:YES];
    }
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderDetailCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 180.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GYOrderDetailFooter *footer = [GYOrderDetailFooter loadXibView];
    footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 180.f);

    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
