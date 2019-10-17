//
//  GYSpecialGoodsVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYSpecialGoodsVC.h"
#import "GYSpecialGoodsCell.h"
#import "GYGoodsDetailVC.h"
#import "GYCateMenuView.h"
#import "GYBrandMenuView.h"

static NSString *const SpecialGoodsCell = @"SpecialGoodsCell";
@interface GYSpecialGoodsVC ()<UITableViewDelegate,UITableViewDataSource,GYCateMenuViewDelegate,GYBrandMenuViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *cateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cateImg;
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seriesImg;
@property (weak, nonatomic) IBOutlet UILabel *seriesLabel;
/* 选中的品牌或者系列 */
@property(nonatomic,strong) UIButton *selectBtn;
/** 分类 */
@property (nonatomic,strong) GYCateMenuView *cateView;
/** 品牌 */
@property (nonatomic,strong) GYBrandMenuView *brandView;
/** 系列 */
@property (nonatomic,strong) GYBrandMenuView *sericesView;
@end

@implementation GYSpecialGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.navTitle];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(GYCateMenuView *)cateView
{
    if (_cateView == nil) {
        _cateView = [[GYCateMenuView alloc] init];
        _cateView.delegate = self;
        _cateView.titleColor = UIColorFromRGB(0x131D2D);
        _cateView.titleHightLightColor = HXControlBg;
    }
    return _cateView;
}
-(GYBrandMenuView *)brandView
{
    if (_brandView == nil) {
        _brandView = [[GYBrandMenuView alloc] init];
        _brandView.delegate = self;
        _brandView.titleColor = UIColorFromRGB(0x131D2D);
        _brandView.titleHightLightColor = HXControlBg;
    }
    return _brandView;
}
-(GYBrandMenuView *)sericesView
{
    if (_sericesView == nil) {
        _sericesView = [[GYBrandMenuView alloc] init];
        _sericesView.delegate = self;
        _sericesView.titleColor = UIColorFromRGB(0x131D2D);
        _sericesView.titleHightLightColor = HXControlBg;
    }
    return _sericesView;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSpecialGoodsCell class]) bundle:nil] forCellReuseIdentifier:SpecialGoodsCell];
}
#pragma mark -- 点击事件
- (IBAction)cateBtnClicked:(UIButton *)sender {
    if (self.brandView.show) {
        [self.brandView menuHidden];
    }
    if (self.sericesView.show) {
        [self.sericesView menuHidden];
    }
    
    if (self.cateView.show) {
        [self.cateView menuHidden];
        return;
    }
    self.selectBtn = nil;
    
    self.cateView.dataType = 1;
    self.cateView.transformImageView = self.cateImg;
    self.cateView.titleLabel = self.cateLabel;
    
    [self.cateView menuShowInSuperView:self.view];
}
- (IBAction)brandBtnClicked:(UIButton *)sender {
    if (self.cateView.show) {
        [self.cateView menuHidden];
    }
    if (self.sericesView.show) {
        [self.sericesView menuHidden];
    }
    
    if (self.brandView.show) {
        [self.brandView menuHidden];
        return;
    }
    self.selectBtn = sender;

    self.brandView.dataType = 1;
    self.brandView.transformImageView = self.brandImg;
    self.brandView.titleLabel = self.brandLabel;
    
    [self.brandView menuShowInSuperView:self.view];
}
- (IBAction)seriesBtnClicked:(UIButton *)sender {
    if (self.cateView.show) {
        [self.cateView menuHidden];
    }
    if (self.brandView.show) {
        [self.brandView menuHidden];
    }
    
    if (self.sericesView.show) {
        [self.sericesView menuHidden];
        return;
    }
    self.selectBtn = sender;
    
    self.sericesView.dataType = 2;
    self.sericesView.transformImageView = self.seriesImg;
    self.sericesView.titleLabel = self.seriesLabel;
    
    [self.sericesView menuShowInSuperView:self.view];
}
#pragma mark -- GYCateMenuViewDelegate
//出现位置
- (CGPoint)cateMenu_positionInSuperView
{
    return CGPointMake(0, 44);
}
//点击事件
- (void)cateMenu:(GYCateMenuView *)menu  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXLog(@"分类筛选确定");
}
#pragma mark -- GYBrandMenuViewDelegate
//出现位置
- (CGPoint)brandMenu_positionInSuperView
{
    return CGPointMake(0, 44);
}
//点击事件
- (void)brandMenu:(GYBrandMenuView *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXLog(@"品牌筛选确定");
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYSpecialGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:SpecialGoodsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 100.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYGoodsDetailVC *dvc = [GYGoodsDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
