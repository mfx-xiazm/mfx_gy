//
//  GYWorkCategoryView.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYWorkCategoryView.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "GYWorkCategoryCell.h"
#import "GYWorkType.h"

static NSString *const WorkCategoryCell = @"WorkCategoryCell";

@interface GYWorkCategoryView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
@implementation GYWorkCategoryView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYWorkCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:WorkCategoryCell];
}
- (IBAction)typeBtnClicked:(UIButton *)sender {
    if (self.workCateCall) {
        self.workCateCall(sender.tag);
    }
}
-(void)setWorkTypes:(NSArray *)workTypes
{
    _workTypes = workTypes;
    [self.collectionView reloadData];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.workTypes.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYWorkCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WorkCategoryCell forIndexPath:indexPath];
    GYWorkType *workType = self.workTypes[indexPath.item];
    cell.workType = workType;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GYWorkType *workType = self.workTypes[indexPath.item];
    workType.isSelected = !workType.isSelected;
    [collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYWorkType *workType = self.workTypes[indexPath.item];
    return CGSizeMake([workType.set_val boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 20, 30);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5, 15, 5, 15);
}

@end
