//
//  GYSalerMyVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYSalerMyVC.h"
#import "GYSalerMyHeader.h"
#import "GYMyCell.h"
#import "GYMySetVC.h"
#import "GYVipMemberVC.h"
#import "GYMyGoodsVC.h"
#import "GYMyBillVC.h"
#import "GYMyNeedsVC.h"
#import "GYSalerMyOrderVC.h"
#import "GYMineData.h"

static NSString *const ProfileCell = @"ProfileCell";
@interface GYSalerMyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GYSalerMyHeader *header;
/* titles */
@property(nonatomic,strong) NSArray *titles;
/* 个人信息 */
@property(nonatomic,strong) GYMineData *mineData;
@end

@implementation GYSalerMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMemberRequest];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 340.f);
}
-(GYSalerMyHeader *)header
{
    if (_header == nil) {
        _header = [GYSalerMyHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 340.f);
        hx_weakify(self);
        _header.salerMyHeaderBtnClickedCall = ^(NSInteger index) {
            hx_strongify(weakSelf);
            if (index<5) {
                GYSalerMyOrderVC *ovc = [GYSalerMyOrderVC new];
                ovc.selectIndex = index;
                [strongSelf.navigationController pushViewController:ovc animated:YES];
            }else if (index == 5) {
                GYMySetVC *svc = [GYMySetVC new];
                svc.mineData = strongSelf.mineData;
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
                    @{@"title":@"我的需求",@"imagename":@"我的需求"},
                    @{@"title":@"我的产品",@"imagename":@"我的产品"},
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
-(void)getMemberRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getMineData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            NSArray *data = [NSArray arrayWithArray:responseObject[@"data"]];
            NSDictionary *dict = data.firstObject;
            strongSelf.mineData = [GYMineData yy_modelWithDictionary:dict];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.header.mineData = strongSelf.mineData;
            });
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
            GYMyNeedsVC *nvc = [GYMyNeedsVC new];
            [self.navigationController pushViewController:nvc animated:YES];
        }
            break;
        case 1:{
            GYMyGoodsVC *gvc = [GYMyGoodsVC new];
            [self.navigationController pushViewController:gvc animated:YES];
        }
            break;
        case 2:{
            GYMyBillVC *bvc = [GYMyBillVC new];
            [self.navigationController pushViewController:bvc animated:YES];
        }
            break;
        default:
            break;
    }
}


@end
