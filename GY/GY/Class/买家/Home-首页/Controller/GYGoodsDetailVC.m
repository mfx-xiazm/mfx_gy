//
//  GYGoodsDetailVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYGoodsDetailVC.h"
#import "GYGoodsDetailHeader.h"
#import "GYGoodsDetailSectionHeader.h"
#import "GYGoodsCommentLayout.h"
#import "GYGoodsCommentCell.h"
#import <WebKit/WebKit.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "GYChooseClassView.h"
#import "GYAllCommentsVC.h"
#import "GYGoodsDetail.h"
#import "GYLoginVC.h"
#import "HXNavigationController.h"
#import "GYVipMemberVC.h"
#import "GYUpOrderVC.h"

@interface GYGoodsDetailVC ()<UITableViewDelegate,UITableViewDataSource,GYGoodsCommentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SPButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UIView *handleToolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleToolViewHeight;
/* 头视图 */
@property(nonatomic,strong) GYGoodsDetailHeader *header;
/** 尾部视图 */
@property(nonatomic,strong) UIView *footer;
/** 商品详情视图 */
@property(nonatomic,strong) WKWebView *webView;
/** 商品详情 */
@property(nonatomic,strong) GYGoodsDetail *goodsDetail;
/** 商品规格视图 */
@property(nonatomic,strong) GYChooseClassView *chooseClassView;
@end

@implementation GYGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"商品详情"];
    [self setUpTableView];
    [self startShimmer];
    [self getGoodDetailRequest];
}
-(GYChooseClassView *)chooseClassView
{
    if (_chooseClassView == nil) {
        _chooseClassView = [GYChooseClassView loadXibView];
        _chooseClassView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 380);
    }
    return _chooseClassView;
}
-(GYGoodsDetailHeader *)header
{
    if (_header == nil) {
        _header = [GYGoodsDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*3/5.0 + 95.f + 160.f + 20.f);
    }
    return _header;
}
-(WKWebView *)webView
{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
        _webView.scrollView.scrollEnabled = NO;
        [self.footer addSubview:_webView];
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}
-(UIView *)footer
{
    if (_footer == nil) {
        _footer = [UIView new];
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
        image.backgroundColor = [UIColor whiteColor];
        image.contentMode = UIViewContentModeCenter;
        image.image = HXGetImage(@"详情标题样式");
        [_footer addSubview:image];

        UILabel *label = [[UILabel alloc] init];
        label.text = @"商品详情";
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 60.f);
        [_footer addSubview:label];
    }
    return _footer;
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
    
    self.tableView.tableHeaderView = self.header;
    
    self.tableView.hidden = YES;
}
#pragma mark -- 点击事件
- (IBAction)addCollectClicked:(SPButton *)sender {
    
    if ([MSUserManager sharedInstance].isLogined) {
        [self getCollectRequest];
    }else{
        HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:[GYLoginVC new]];
        if (@available(iOS 13.0, *)) {
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
            nav.modalInPresentation = YES;
        }
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (IBAction)shareClicked:(SPButton *)sender {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    hx_weakify(self);
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        hx_strongify(weakSelf);
        [strongSelf shareToPlatformType:UMSocialPlatformType_WechatSession];
    }];
}
- (IBAction)lookContactClicked:(UIButton *)sender {
    hx_weakify(self);
    if ([MSUserManager sharedInstance].isLogined) {
        [self getMemberRequestCompletedCall:^(NSInteger member_id) {
            hx_strongify(weakSelf);
            if (member_id) {
                [strongSelf getContactRequest];
            }else{
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
                strongSelf.zh_popupController = [[zhPopupController alloc] init];
                [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }];
    }else{
        HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:[GYLoginVC new]];
        if (@available(iOS 13.0, *)) {
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
            nav.modalInPresentation = YES;
        }
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (IBAction)chooseGoodsClassClicked:(UIButton *)sender {
    if ([MSUserManager sharedInstance].isLogined) {
        self.chooseClassView.goodsDetail = self.goodsDetail;
        hx_weakify(self);
        self.chooseClassView.goodsHandleCall = ^(NSInteger type) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
            if (type) {
                if (type == 1) {
                    [strongSelf addOrderCartRequest];
                }else{
                    GYUpOrderVC *ovc = [GYUpOrderVC new];
                    ovc.goods_id = strongSelf.goods_id;//商品id
                    ovc.goods_num = [NSString stringWithFormat:@"%ld",(long)strongSelf.goodsDetail.buyNum];//商品数量
                    if (strongSelf.goodsDetail.spec && strongSelf.goodsDetail.spec.count) {
                        NSMutableString *spec_values = [NSMutableString string];
                        for (GYGoodSpec *spec in strongSelf.goodsDetail.spec) {
                            if (spec_values.length) {
                                [spec_values appendFormat:@" %@",spec.selectSpec.spec_value];
                            }else{
                                [spec_values appendFormat:@"%@",spec.selectSpec.spec_value];
                            }
                        }
                        ovc.spec_values = spec_values;//商品规格
                    }else{
                        ovc.spec_values = @"";//商品规格
                    }
                    [strongSelf.navigationController pushViewController:ovc animated:YES];
                }
            }
        };
        self.zh_popupController = [[zhPopupController alloc] init];
        self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
        [self.zh_popupController presentContentView:self.chooseClassView duration:0.25 springAnimated:NO];
    }else{
        HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:[GYLoginVC new]];
        if (@available(iOS 13.0, *)) {
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
            nav.modalInPresentation = YES;
        }
        [self presentViewController:nav animated:YES completion:nil];
    }
}
#pragma mark -- 接口请求
-(void)getGoodDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getGoodDetail" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.goodsDetail = [GYGoodsDetail yy_modelWithDictionary:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.tableView.hidden = NO;
                [strongSelf handleShopDetailInfo];
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
-(void)handleShopDetailInfo
{
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, [self.goodsDetail.goods_type isEqualToString:@"2"]?HX_SCREEN_WIDTH*3/5.0 + 95.f + 120.f + 20.f : HX_SCREEN_WIDTH*3/5.0 + 95.f + 160.f + 20.f);
    self.header.goodsDetail = self.goodsDetail;
    
    self.tableView.tableHeaderView = self.header;
    
    [self.tableView reloadData];
    
    if (HX_SCREEN_WIDTH > 375.f) {
        [self.webView loadHTMLString:self.goodsDetail.goods_detail baseURL:nil];
    }else{
        NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:0 15px;}</style></head><body>%@</body></html>",self.goodsDetail.goods_detail];
        [self.webView loadHTMLString:h5 baseURL:nil];
    }
    
    self.collectBtn.selected = self.goodsDetail.collected;
    
    if ([MSUserManager sharedInstance].isLogined) {// 已登录
        if ([MSUserManager sharedInstance].curUserInfo.utype == 1) {
            if ([self.goodsDetail.goods_type isEqualToString:@"2"]) {
                self.contactBtn.hidden = NO;
            }else{
                self.contactBtn.hidden = YES;
            }
        }else{
            self.handleToolView.hidden = YES;
            self.handleToolViewHeight.constant = 0.f;
        }
    }else{// 未登录
        if ([self.goodsDetail.goods_type isEqualToString:@"2"]) {
            self.contactBtn.hidden = NO;
        }else{
            self.contactBtn.hidden = YES;
        }
    }
}
#pragma mark -- 业务逻辑
-(void)getCollectRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"collectGood" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
            strongSelf.collectBtn.selected = !strongSelf.collectBtn.isSelected;
            strongSelf.goodsDetail.collected = strongSelf.collectBtn.isSelected;
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getMemberRequestCompletedCall:(void(^)(NSInteger member_id))completedCall
{
    [HXNetworkTool POST:HXRC_M_URL action:@"getMineData" parameters:@{} success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            NSArray *data = [NSArray arrayWithArray:responseObject[@"data"]];
            NSDictionary *dict = data.firstObject;
            completedCall([dict[@"member_id"] integerValue]);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getContactRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getContact" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            NSArray *data = [NSArray arrayWithArray:responseObject[@"data"]];
            NSDictionary *dict = data.firstObject;
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"姓名：%@\n电话：%@",dict[@"contact_name"],dict[@"contact_phone"]] constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确定" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
            }];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
            [alert addAction:okButton];
            strongSelf.zh_popupController = [[zhPopupController alloc] init];
            [strongSelf.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)addOrderCartRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"goods_id"] = self.goods_id;//商品id
    parameters[@"cart_num"] = @(self.goodsDetail.buyNum);//商品数量
    if (self.goodsDetail.spec && self.goodsDetail.spec.count) {
        NSMutableString *spec_values = [NSMutableString string];
        for (GYGoodSpec *spec in self.goodsDetail.spec) {
            if (spec_values.length) {
                [spec_values appendFormat:@" %@",spec.selectSpec.spec_value];
            }else{
                [spec_values appendFormat:@"%@",spec.selectSpec.spec_value];
            }
        }
        parameters[@"spec_values"] = spec_values;//商品规格
    }else{
        parameters[@"spec_values"] = @"";//商品规格
    }

    [HXNetworkTool POST:HXRC_M_URL action:@"addOrderCart" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (void)shareToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"工流界" descr:@"电气设备、照明器材、金属制品、机械设备、建材、环保设备、劳保用品、消防设备、的批发兼零售商城" thumImage:HXGetImage(@"AppIcon")];
    /* 网页链接 */
    shareObject.webpageUrl = @"http://gongliujie.mfxapp.com/sharePage/download.html";
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:resp.message];
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}
#pragma mark -- 事件监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webView.frame = CGRectMake(0, 60.f, HX_SCREEN_WIDTH, self.webView.scrollView.contentSize.height);
        self.footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.webView.scrollView.contentSize.height + 60.f);
        self.tableView.tableFooterView = self.footer;
    }
}
-(void)dealloc
{
    @try {
        HXLog(@"销毁");
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
    @catch (NSException *exception) {
        HXLog(@"多次删除了");
    }
    @finally {
        HXLog(@"多次删除了");
    }
}
#pragma mark -- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsDetail.evaLayout ?1:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYGoodsCommentLayout *layout = self.goodsDetail.evaLayout;
    return layout.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYGoodsCommentCell * cell = [GYGoodsCommentCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.targetVc = self;
    GYGoodsCommentLayout *layout = self.goodsDetail.evaLayout;
    cell.commentLayout = layout;
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GYGoodsDetailSectionHeader *header = [GYGoodsDetailSectionHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44.f);
    hx_weakify(self);
    header.moreClickedCall = ^{
        hx_strongify(weakSelf);
        GYAllCommentsVC *mvc = [GYAllCommentsVC new];
        mvc.goods_id = strongSelf.goods_id;
        [strongSelf.navigationController pushViewController:mvc animated:YES];
    };
    return header;
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
