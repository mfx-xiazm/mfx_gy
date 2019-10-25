//
//  GYHomeBannerHeader.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYHomeBannerHeader.h"
#import "GYBannerCell.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import "GYTopNoticeCell.h"
#import <GYRollingNoticeView.h>

@interface GYHomeBannerHeader ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, GYRollingNoticeViewDataSource, GYRollingNoticeViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (nonatomic,strong) GYRollingNoticeView *roolNoticeView;
@end
@implementation GYHomeBannerHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cyclePagerView.isInfiniteLoop = YES;
    self.cyclePagerView.autoScrollInterval = 3.0;
    self.cyclePagerView.dataSource = self;
    self.cyclePagerView.delegate = self;
    // registerClass or registerNib
    [self.cyclePagerView registerNib:[UINib nibWithNibName:NSStringFromClass([GYBannerCell class]) bundle:nil] forCellWithReuseIdentifier:@"TopBannerCell"];
    
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    pageControl.numberOfPages = 4;
    pageControl.currentPageIndicatorSize = CGSizeMake(6, 6);
    pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    //    pageControl.pageIndicatorImage = HXGetImage(@"轮播点灰");
    //    pageControl.currentPageIndicatorImage = HXGetImage(@"轮播点黑");
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20, CGRectGetWidth(self.cyclePagerView.frame), 20);
    self.pageControl = pageControl;
    [self.cyclePagerView addSubview:pageControl];
    
    GYRollingNoticeView *noticeView = [[GYRollingNoticeView alloc]initWithFrame:self.noticeView.bounds];
    noticeView.dataSource = self;
    noticeView.delegate = self;
    [noticeView registerNib:[UINib nibWithNibName:@"GYTopNoticeCell" bundle:nil] forCellReuseIdentifier:@"TopNoticeCell"];
    self.roolNoticeView = noticeView;
    [self.noticeView addSubview:noticeView];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20, CGRectGetWidth(self.cyclePagerView.frame), 20);
    self.roolNoticeView.frame = self.noticeView.bounds;
}
-(void)setHomeAdv:(NSArray<GYHomeBanner *> *)homeAdv
{
    _homeAdv = homeAdv;
    self.pageControl.numberOfPages = _homeAdv.count;
    [self.cyclePagerView reloadData];
}
-(void)setHomeNotice:(NSArray<GYHomeNotice *> *)homeNotice
{
    _homeNotice = homeNotice;
    [self.roolNoticeView reloadDataAndStartRoll];
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.homeAdv.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    GYBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
    GYHomeBanner *banner = self.homeAdv[index];
    cell.banner = banner;
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 0;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if (self.bannerOrNoticeCall) {
        self.bannerOrNoticeCall(1,index);
    }
}
#pragma mark -- GYRollingNoticeView数据源和代理
- (NSInteger)numberOfRowsForRollingNoticeView:(GYRollingNoticeView *)rollingView
{
    return self.homeNotice.count;
}
- (__kindof GYNoticeViewCell *)rollingNoticeView:(GYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index
{
    GYTopNoticeCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"TopNoticeCell"];
    GYHomeNotice *notice = self.homeNotice[index];
    cell.notice = notice;
    return cell;
}

- (void)didClickRollingNoticeView:(GYRollingNoticeView *)rollingView forIndex:(NSUInteger)index
{
    if (self.bannerOrNoticeCall) {
        self.bannerOrNoticeCall(2,index);
    }
}
@end
