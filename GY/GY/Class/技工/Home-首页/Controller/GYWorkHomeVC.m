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
@end

@implementation GYWorkHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
    HXLog(@"地区确定");
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
    HXLog(@"需求确定");
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYMyNeedsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyNeedsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
