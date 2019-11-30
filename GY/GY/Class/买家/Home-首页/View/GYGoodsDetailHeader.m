//
//  GYGoodsDetailHeader.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYGoodsDetailHeader.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import "GYBannerCell.h"
#import "GYGoodsDetail.h"

@interface GYGoodsDetailHeader ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *goods_type;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *stock_num;
@property (weak, nonatomic) IBOutlet UILabel *serice_name;
@property (weak, nonatomic) IBOutlet UILabel *goods_model;
@property (weak, nonatomic) IBOutlet UILabel *freight;
@property (weak, nonatomic) IBOutlet UIView *freightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freightViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeight;

@end
@implementation GYGoodsDetailHeader

-(void)awakeFromNib
{
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
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20, CGRectGetWidth(self.cyclePagerView.frame), 20);
}
-(void)setGoodsDetail:(GYGoodsDetail *)goodsDetail
{
    _goodsDetail = goodsDetail;
    
    [self.goods_name setTextWithLineSpace:5.f withString:_goodsDetail.goods_name withFont:[UIFont systemFontOfSize:14]];
    if ([_goodsDetail.goods_type isEqualToString:@"1"]) {
        self.goods_type.text = @" 直营商品 ";
    }else if ([_goodsDetail.goods_type isEqualToString:@"2"]) {
        self.goods_type.text = @" 积压甩卖 ";
    }else{
        self.goods_type.text = @" 经销商商品 ";
    }
    self.price.text = [NSString stringWithFormat:@"会员价%@",_goodsDetail.price];
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_goodsDetail.market_price]];
    self.stock_num.text = _goodsDetail.stock_num;
    self.serice_name.text = _goodsDetail.series_name;
    self.goods_model.text = _goodsDetail.goods_model;
    if ([_goodsDetail.goods_type isEqualToString:@"2"]) {
        self.infoViewHeight.constant = 120.f;
        self.freightViewHeight.constant = 0.f;
        self.freightView.hidden = YES;
    }else{
        self.infoViewHeight.constant = 160.f;
        self.freightViewHeight.constant = 40.f;
        self.freightView.hidden = NO;
        self.freight.text = _goodsDetail.freight;
    }
    
    self.pageControl.numberOfPages = _goodsDetail.good_adv.count;
    [self.cyclePagerView reloadData];
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.goodsDetail.good_adv.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    GYBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
    GYGoodAdv *adv = self.goodsDetail.good_adv[index];
    cell.adv = adv;
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
    
}
@end
