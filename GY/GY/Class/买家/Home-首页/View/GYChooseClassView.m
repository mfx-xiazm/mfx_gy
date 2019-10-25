//
//  GYChooseClassView.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYChooseClassView.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GYChooseClassCell.h"
#import "GYChooseClassHeader.h"
#import "GYChooseClassFooter.h"
#import "GYGoodsDetail.h"

static NSString *const ChooseClassCell = @"ChooseClassCell";
static NSString *const ChooseClassHeader = @"ChooseClassHeader";
static NSString *const ChooseClassFooter = @"ChooseClassFooter";

@interface GYChooseClassView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *cover_img;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *stock_num;

@end
@implementation GYChooseClassView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYChooseClassCell class]) bundle:nil] forCellWithReuseIdentifier:ChooseClassCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYChooseClassHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYChooseClassFooter class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ChooseClassFooter];
}
- (IBAction)goodHandleClicked:(UIButton *)sender {
   
    if (sender.tag) {
        BOOL isChooseed = YES;
        if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
            for (GYGoodSpec *spec in self.goodsDetail.spec) {
                if (!spec.selectSpec) {
                    isChooseed = NO;
                    break;
                }
            }
        }
        if (!isChooseed) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择商品规则"];
            return;
        }
        if (self.goodsHandleCall) {
            self.goodsHandleCall(sender.tag);
        }
    }else{
        if (self.goodsHandleCall) {
            self.goodsHandleCall(sender.tag);
        }
    }
}

-(void)setGoodsDetail:(GYGoodsDetail *)goodsDetail
{
    _goodsDetail = goodsDetail;
    
    [self.cover_img sd_setImageWithURL:[NSURL URLWithString:_goodsDetail.cover_img]];
    self.price.text = [NSString stringWithFormat:@"会员价%@",_goodsDetail.price];
    [self.market_price setLabelUnderline:[NSString stringWithFormat:@"市场价：￥%@",_goodsDetail.market_price]];
    self.stock_num.text = [NSString stringWithFormat:@"库存：%@",_goodsDetail.stock_num];
    [self.collectionView reloadData];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        return self.goodsDetail.spec.count;
    }else{
        return 1;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        GYGoodSpec *spec = self.goodsDetail.spec[section];
        return spec.spec_val.count;
    }else{
        return 0;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYChooseClassCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChooseClassCell forIndexPath:indexPath];
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        GYGoodSpec *spec = self.goodsDetail.spec[indexPath.section];
        GYGoodSubSpec *subSpec = spec.spec_val[indexPath.item];
        cell.subSpec = subSpec;
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        GYGoodSpec *spec = self.goodsDetail.spec[indexPath.section];
        spec.selectSpec.isSelected = NO;
        
        GYGoodSubSpec *subSpec = spec.spec_val[indexPath.item];
        subSpec.isSelected = YES;
        
        spec.selectSpec = subSpec;
        
        [collectionView reloadData];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        return CGSizeMake(HX_SCREEN_WIDTH,40.f);
    }else{
        return CGSizeZero;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(HX_SCREEN_WIDTH,40.f);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        GYChooseClassHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ChooseClassHeader forIndexPath:indexPath];
        if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
            GYGoodSpec *spec = self.goodsDetail.spec[indexPath.section];
            header.spec_name.text = spec.spec_name;
            return header;
        }else{
            return nil;
        }
    }else{
        GYChooseClassFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ChooseClassFooter forIndexPath:indexPath];
        footer.stock_num = [self.goodsDetail.stock_num integerValue];
        footer.buy_num.text = [NSString stringWithFormat:@"%zd",self.goodsDetail.buyNum];
        hx_weakify(self);
        footer.buyNumCall = ^(NSInteger num) {
            hx_strongify(weakSelf);
            strongSelf.goodsDetail.buyNum = num;
        };
        return footer;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        GYGoodSpec *spec = self.goodsDetail.spec[indexPath.section];
        GYGoodSubSpec *subSpec = spec.spec_val[indexPath.item];
        return CGSizeMake([subSpec.spec_value boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.width + 20, 30);
    }else{
        return CGSizeZero;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}
@end
