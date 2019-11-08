//
//  GYAllCommentsVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYAllCommentsVC.h"
#import "GYGoodsCommentLayout.h"
#import "GYGoodsCommentCell.h"
#import "GYCommentTypeCell.h"
#import <ZLCollectionViewVerticalLayout.h>

static NSString *const CommentTypeCell = @"CommentTypeCell";
@interface GYAllCommentsVC ()<UITableViewDelegate,UITableViewDataSource,GYGoodsCommentCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
/** 页码 */
@property(nonatomic,assign) NSInteger pagenum;
/** 评论布局数组 */
@property (nonatomic,strong) NSMutableArray *commentLayoutsArr;
/* 总数 */
@property(nonatomic,copy) NSString *totalCount;
/* 好评 */
@property(nonatomic,copy) NSString *highCount;
/* 中评 */
@property(nonatomic,copy) NSString *middleCount;
/* 差评 */
@property(nonatomic,copy) NSString *lowCount;
/* 选择的评价方式 */
@property(nonatomic,assign) NSInteger selectedIndex;
/* 评价等级 */
@property(nonatomic,copy) NSString *commentType;
@end

@implementation GYAllCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"全部评价"];
    
    /* 总数 */
    self.totalCount = @"全部评价";
    /* 好评 */
    self.highCount = @"好评";
    /* 中评 */
    self.middleCount = @"中评";
    /* 差评 */
    self.lowCount = @"差评（%@）";
    
    [self setUpCollectionView];
    [self setUpTableView];
    [self setUpRefresh];
    [self startShimmer];
    [self getAllCommentDataRequest];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.collectionViewHeight.constant = self.collectionView.contentSize.height;
    });
}
-(NSMutableArray *)commentLayoutsArr
{
    if (!_commentLayoutsArr) {
        _commentLayoutsArr = [NSMutableArray array];
    }
    return _commentLayoutsArr;
}
#pragma mark -- 视图相关
- (void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYCommentTypeCell class]) bundle:nil] forCellWithReuseIdentifier:CommentTypeCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
        [strongSelf getCommentListRequest:YES completedCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf getCommentListRequest:NO completedCall:^{
            [strongSelf.tableView reloadData];
        }];
    }];
}
#pragma mark -- 数据请求
-(void)getAllCommentDataRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序1
    hx_weakify(self);
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"goods_id"] = self.goods_id;//商品id
        
        [HXNetworkTool POST:HXRC_M_URL action:@"getGoodEvaCountData" parameters:parameters success:^(id responseObject) {
            if([[responseObject objectForKey:@"status"] integerValue] == 1) {
                /* 总数 */
                strongSelf.totalCount = [NSString stringWithFormat:@"全部评价(%@)",responseObject[@"data"][@"totalCount"]];
                /* 好评 */
                strongSelf.highCount = [NSString stringWithFormat:@"好评(%@)",responseObject[@"data"][@"highCount"]];
                /* 中评 */
                strongSelf.middleCount = [NSString stringWithFormat:@"中评(%@)",responseObject[@"data"][@"middleCount"]];
                /* 差评 */
                strongSelf.lowCount = [NSString stringWithFormat:@"差评(%@)",responseObject[@"data"][@"lowCount"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getCommentListRequest:YES completedCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        // 执行顺序10
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            hx_strongify(weakSelf);
            [strongSelf stopShimmer];
            strongSelf.collectionView.hidden = NO;
            [strongSelf.collectionView reloadData];
            strongSelf.tableView.hidden = NO;
            [strongSelf.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                strongSelf.collectionViewHeight.constant = strongSelf.collectionView.contentSize.height;
            });
        });
    });
}
-(void)getCommentListRequest:(BOOL)isRefresh completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    parameters[@"type"] = (self.commentType && self.commentType.length)?self.commentType:@"4";//type 为1查询差评 2中评；3好评;为4查询全部评价
    if (isRefresh) {
        parameters[@"page"] = @(1);//第几页
    }else{
        NSInteger page = self.pagenum+1;
        parameters[@"page"] = @(page);//第几页
    }
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getGoodEvaList" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (isRefresh) {
                [strongSelf.tableView.mj_header endRefreshing];
                strongSelf.pagenum = 1;
                
                [strongSelf.commentLayoutsArr removeAllObjects];
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYGoodsComment class] json:responseObject[@"data"]];
                for (GYGoodsComment *comment in arrt) {
                    GYGoodsCommentLayout *layout = [[GYGoodsCommentLayout alloc] initWithModel:comment];
                    [strongSelf.commentLayoutsArr addObject:layout];
                }
            }else{
                [strongSelf.tableView.mj_footer endRefreshing];
                strongSelf.pagenum ++;
                
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]] && ((NSArray *)responseObject[@"data"]).count){
                    NSArray *arrt = [NSArray yy_modelArrayWithClass:[GYGoodsComment class] json:responseObject[@"data"]];
                    for (GYGoodsComment *comment in arrt) {
                        GYGoodsCommentLayout *layout = [[GYGoodsCommentLayout alloc] initWithModel:comment];
                        [strongSelf.commentLayoutsArr addObject:layout];
                    }
                }else{// 提示没有更多数据
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
        if (completedCall) {
            completedCall();
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completedCall) {
            completedCall();
        }
    }];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYCommentTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CommentTypeCell forIndexPath:indexPath];
    if (indexPath.item == 0) {
        cell.typeLabel.text = self.totalCount;
    }else if (indexPath.item == 1) {
        cell.typeLabel.text = self.highCount;
    }else if (indexPath.item == 2) {
        cell.typeLabel.text = self.middleCount;
    }else{
        cell.typeLabel.text = self.lowCount;
    }
    if (indexPath.item == self.selectedIndex) {
        cell.typeLabel.backgroundColor = HXControlBg;
        cell.typeLabel.textColor = [UIColor whiteColor];
        cell.typeLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        cell.typeLabel.backgroundColor = [UIColor whiteColor];
        cell.typeLabel.textColor = UIColorFromRGB(0x666666);
        cell.typeLabel.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    // 1查询差评 2中评；3好评;为4查询全部评价
    if (indexPath.item == 0) {
        self.commentType = @"4";
    }else if (indexPath.item == 1) {
        self.commentType = @"3";
    }else if (indexPath.item == 2) {
        self.commentType = @"2";
    }else{
        self.commentType = @"1";
    }
    [collectionView reloadData];
    
    hx_weakify(self);
    [self getCommentListRequest:YES completedCall:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView reloadData];
    }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *numText = nil;
    if (indexPath.item == 0) {
        numText = self.totalCount;
    }else if (indexPath.item == 1) {
        numText = self.highCount;
    }else if (indexPath.item == 2) {
        numText = self.middleCount;
    }else{
        numText = self.lowCount;
    }
    return CGSizeMake([numText boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.width + 30, 30);
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
#pragma mark -- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentLayoutsArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYGoodsCommentLayout *layout = self.commentLayoutsArr[indexPath.row];
    return layout.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYGoodsCommentCell * cell = [GYGoodsCommentCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GYGoodsCommentLayout *layout = self.commentLayoutsArr[indexPath.row];
    cell.commentLayout = layout;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -- GYGoodsCommentCellDelegate
/** 点击了全文/收回 */
-(void)didClickMoreLessInCommentCell:(GYGoodsCommentCell *)Cell
{
    GYGoodsCommentLayout *layout = Cell.commentLayout;
    layout.comment.isOpening = !layout.comment.isOpening;
    
    [layout resetLayout];
    [self.tableView reloadData];
}


@end
