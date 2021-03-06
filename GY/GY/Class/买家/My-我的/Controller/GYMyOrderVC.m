//
//  GYMyOrderVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyOrderVC.h"
#import "GYMyOrderChildVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "GYUpOrderVC.h"

@interface GYMyOrderVC ()<JXCategoryViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/** vc控制器 */
@property (nonatomic,strong) NSMutableArray *controllers;

@end

@implementation GYMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的订单"];
    if (self.isPushOrder) {
        hx_weakify(self);
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[GYUpOrderVC class]]) {
                hx_strongify(weakSelf);
                [strongSelf.controllers removeObjectAtIndex:idx];
                *stop = YES;
            }
        }];
        [self.navigationController setViewControllers:self.controllers];
    }
    [self setUpCategoryView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    }
    return _controllers;
}
-(NSArray *)childVCs
{
    if (_childVCs == nil) {
        NSMutableArray *vcs = [NSMutableArray array];
        for (int i=0;i<self.categoryView.titles.count;i++) {
            GYMyOrderChildVC *cvc0 = [GYMyOrderChildVC new];
            cvc0.status = i;
            [self addChildViewController:cvc0];
            [vcs addObject:cvc0];
        }
        _childVCs = vcs;
    }
    return _childVCs;
}
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titles = @[@"全部", @"待付款", @"待发货",@"待收货", @"待评价", @"已完成"];
    _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _categoryView.titleColor = [UIColor blackColor];
    _categoryView.titleSelectedColor = HXControlBg;
    _categoryView.defaultSelectedIndex = self.selectIndex;
    _categoryView.delegate = self;
    _categoryView.contentScrollView = self.scrollView;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _categoryView.indicators = @[lineView];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(HX_SCREEN_WIDTH*self.childVCs.count, 0);
    
    // 加第一个视图
    UIViewController *targetViewController = self.childVCs[self.selectIndex];
    targetViewController.view.frame = CGRectMake(self.selectIndex*HX_SCREEN_WIDTH, 0, HX_SCREEN_WIDTH, _scrollView.hxn_height);
    [_scrollView addSubview:targetViewController.view];
}
#pragma mark - JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    // 处理侧滑手势
    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    
    if (self.childVCs.count <= index) {return;}
    
    UIViewController *targetViewController = self.childVCs[index];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(HX_SCREEN_WIDTH * index, 0, HX_SCREEN_WIDTH, self.scrollView.hxn_height);
    
    [self.scrollView addSubview:targetViewController.view];
}
@end
