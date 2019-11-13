//
//  GYMyNeedsDetailVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYMyNeedsDetailVC.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import "GYBannerCell.h"
#import "GYMyTaskDetail.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GYVipMemberVC.h"

@interface GYMyNeedsDetailVC ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *content_view;
@property (weak, nonatomic) IBOutlet UILabel *task_no;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *task_title;
@property (weak, nonatomic) IBOutlet UILabel *task_type;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *task_time;
@property (weak, nonatomic) IBOutlet UILabel *task_content;
@property (weak, nonatomic) IBOutlet UILabel *task_address;
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cyclePagerView;
@property (weak, nonatomic) IBOutlet UIView *contact_header;
@property (weak, nonatomic) IBOutlet UILabel *contact_title;
@property (weak, nonatomic) IBOutlet UILabel *contact_name;
@property (weak, nonatomic) IBOutlet UIButton *rePublishBtn;
@property (nonatomic,strong) TYPageControl *pageControl;
/* 详情 */
@property(nonatomic,strong) GYMyTaskDetail *taskDetail;
/* 是否是会员 */
@property(nonatomic,assign) NSInteger is_member;
@end

@implementation GYMyNeedsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"需求详情"];
    [self setUpCyclePagerView];
    [self startShimmer];
    if (self.isToTake) {
        [self getMemberRequest];
    }
    [self getTaskDetailRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.cyclePagerView.frame) - 20, CGRectGetWidth(self.cyclePagerView.frame), 20);
}
-(void)setUpCyclePagerView
{
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
#pragma mark -- 请求
-(void)getMemberRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getMineData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            NSArray *data = [NSArray arrayWithArray:responseObject[@"data"]];
            NSDictionary *dict = data.firstObject;
            strongSelf.is_member = [dict[@"member_id"] integerValue];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getTaskDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"task_id"] = self.task_id;//需求id

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getTaskInfo" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.taskDetail = [GYMyTaskDetail yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleDetailInfo];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)handleDetailInfo
{
    self.content_view.hidden = NO;
    [self.task_title setTextWithLineSpace:5.f withString:self.taskDetail.task_title withFont:[UIFont systemFontOfSize:13]];
    self.create_time.text = [NSString stringWithFormat:@"发布时间：%@",self.taskDetail.create_time];
    self.task_no.text = [NSString stringWithFormat:@"单号：%@",self.taskDetail.task_no];
    self.pageControl.numberOfPages = self.taskDetail.taskImgs.count;
    self.price.text = [NSString stringWithFormat:@"价格：%@",self.taskDetail.task_price];
    self.task_type.text = [NSString stringWithFormat:@"%@",self.taskDetail.task_type];
    self.task_time.text = [NSString stringWithFormat:@"需求时间：%@ %@",self.taskDetail.task_date,self.taskDetail.task_time];
    self.task_content.text = [NSString stringWithFormat:@"需求描述：%@",self.taskDetail.task_content];
    self.task_address.text = [NSString stringWithFormat:@"%@%@%@",self.taskDetail.province_name,self.taskDetail.city_name,self.taskDetail.address];
    
    if (self.isToTake) {
        self.contact_header.hidden = YES;
        self.contact_name.hidden = YES;
        self.rePublishBtn.hidden = NO;
        [self.rePublishBtn setTitle:@"我要接单" forState:UIControlStateNormal];
        // 需求方信息
        self.contact_title.text = @"需求方信息";
        [self.contact_name setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"姓名：%@\n手机号：%@",self.taskDetail.contact_name,self.taskDetail.contact_phone] withFont:[UIFont systemFontOfSize:13]];
    }else if (self.isTaked) {
        self.rePublishBtn.hidden = YES;
        self.contact_header.hidden = NO;
        self.contact_name.hidden = NO;
        // 需求方信息
        self.contact_title.text = @"需求方信息";
        [self.contact_name setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"姓名：%@\n手机号：%@",self.taskDetail.contact_name,self.taskDetail.contact_phone] withFont:[UIFont systemFontOfSize:13]];
    }else{
        // 1查询未接单 2查询已接单
        if ([self.taskDetail.task_status isEqualToString:@"1"]) {
            self.contact_header.hidden = YES;
            self.contact_name.hidden = YES;
            self.rePublishBtn.hidden = YES;
        }else{
            self.contact_header.hidden = NO;
            self.contact_name.hidden = NO;
            self.rePublishBtn.hidden = NO;
            // 技工信息
            self.contact_title.text = @"技工信息";
            [self.contact_name setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"姓名：%@\n手机号：%@\n维修工种：%@",self.taskDetail.user_name,self.taskDetail.phone,self.taskDetail.work_types] withFont:[UIFont systemFontOfSize:13]];
        }
    }
    
    [self.cyclePagerView reloadData];
}
-(void)republishTaskRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"task_id"] = self.task_id;//需求id
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"republishTask" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.rePublishCall) {
                strongSelf.rePublishCall();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)receiveTaskRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"task_id"] = self.task_id;//需求id
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"receiveTask" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"接单成功"];
            if (strongSelf.rePublishCall) {
                strongSelf.rePublishCall();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (IBAction)rePublishClicked:(UIButton *)sender {
    if (self.isToTake) {
        if (self.is_member) {
            hx_weakify(self);
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"姓名：%@\n电话：%@",self.taskDetail.contact_name,self.taskDetail.contact_phone] constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确定" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
                [strongSelf receiveTaskRequest];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            self.zh_popupController = [[zhPopupController alloc] init];
            [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }else{
            hx_weakify(self);
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"您还不是会员，需要先充值成为会员哦~" constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"去充值" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
                GYVipMemberVC *mvc = [GYVipMemberVC new];
                [strongSelf.navigationController pushViewController:mvc animated:YES];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            self.zh_popupController = [[zhPopupController alloc] init];
            [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }
    }else{
        hx_weakify(self);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要重新发布吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确定" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
            [strongSelf republishTaskRequest];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.taskDetail.taskImgs.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    GYBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCell" forIndex:index];
    NSDictionary *dict = (NSDictionary *)self.taskDetail.taskImgs[index];
    cell.bannerDict = dict;
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
