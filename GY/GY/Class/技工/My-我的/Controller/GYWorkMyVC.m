//
//  GYWorkMyVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYWorkMyVC.h"
#import "GYWorkMyHeader.h"
#import "GYMyCell.h"
#import "GYMySetVC.h"
#import "GYVipMemberVC.h"
#import "GYMyBillVC.h"
#import "GYMyNeedsVC.h"
#import "GYAuthInfoVC.h"

static NSString *const ProfileCell = @"ProfileCell";
@interface GYWorkMyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GYWorkMyHeader *header;
/* titles */
@property(nonatomic,strong) NSArray *titles;

@end

@implementation GYWorkMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 250.f);
}
-(GYWorkMyHeader *)header
{
    if (_header == nil) {
        _header = [GYWorkMyHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 250.f);
        hx_weakify(self);
        _header.workMyHeaderBtnClickedCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index == 1) {
                GYMySetVC *svc = [GYMySetVC new];
                [strongSelf.navigationController pushViewController:svc animated:YES];
            }else{
                GYVipMemberVC *mvc = [GYVipMemberVC new];
                [strongSelf.navigationController pushViewController:mvc animated:YES];
            }
        };
    }
    return _header;
}
-(NSArray *)titles
{
    if (_titles == nil) {
        _titles = @[
                    @{@"title":@"认证信息查看",@"imagename":@"认证信息"},
                    @{@"title":@"我的需求",@"imagename":@"我的需求"},
                    @{@"title":@"我的接单",@"imagename":@"我的接单"},
                    @{@"title":@"我的账单",@"imagename":@"我的账单"}
                    ];
        
    }
    return _titles;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYMyCell class]) bundle:nil] forCellReuseIdentifier:ProfileCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 业务逻辑

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYMyCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *temp = self.titles[indexPath.row];
    cell.name.text = temp[@"title"];
    cell.img.image = HXGetImage(temp[@"imagename"]);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            GYAuthInfoVC *avc = [GYAuthInfoVC new];
            [self.navigationController pushViewController:avc animated:YES];
        }
            break;
        case 1:{
            GYMyNeedsVC *nvc = [GYMyNeedsVC new];
            [self.navigationController pushViewController:nvc animated:YES];
        }
            break;
        case 2:{
           
        }
            break;
        case 3:{
            GYMyBillVC *bvc = [GYMyBillVC new];
            [self.navigationController pushViewController:bvc animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
