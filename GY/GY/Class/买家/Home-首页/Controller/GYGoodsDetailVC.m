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

@interface GYGoodsDetailVC ()<UITableViewDelegate,WKNavigationDelegate,UITableViewDataSource,GYGoodsCommentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GYGoodsDetailHeader *header;
/** 评论布局数组 */
@property (nonatomic,strong) NSMutableArray *commentLayoutsArr;
/** 尾部视图 */
@property(nonatomic,strong) UIView *footer;
/* https://www.jianshu.com/p/7179e886a109 */
@property(nonatomic,strong) WKWebView *webView;
@end

@implementation GYGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"商品详情"];
    [self setUpTableView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/7179e886a109"]]];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*3/5.0 + 95.f + 160.f + 20.f);
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
        _webView.navigationDelegate = self;
        [self.footer addSubview:_webView];
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}
-(NSMutableArray *)commentLayoutsArr
{
    if (!_commentLayoutsArr) {
        _commentLayoutsArr = [NSMutableArray array];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment2" ofType:@"plist"];
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary *dict in dataArray) {
            GYGoodsComment *model = [GYGoodsComment yy_modelWithDictionary:dict];
            GYGoodsCommentLayout *layout = [[GYGoodsCommentLayout alloc] initWithModel:model];
            [_commentLayoutsArr addObject:layout];
        }
    }
    return _commentLayoutsArr;
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
}
#pragma mark -- 点击事件
- (IBAction)addCollectClicked:(SPButton *)sender {
    hx_weakify(self);
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"您还不是会员，需要先充值成为会员哦~" constantWidth:HX_SCREEN_WIDTH - 50*2];
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"去充值" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}

- (IBAction)shareClicked:(SPButton *)sender {
    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"未安装微信客户端"];
    }else{
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
        hx_weakify(self);
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            hx_strongify(weakSelf);
            [strongSelf shareToPlatformType:UMSocialPlatformType_WechatSession];
        }];
    }
}

- (IBAction)chooseGoodsClassClicked:(UIButton *)sender {
    GYChooseClassView *cv = [GYChooseClassView loadXibView];
    cv.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 380);

    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:cv duration:0.25 springAnimated:NO];
}
#pragma mark -- 业务逻辑
- (void)shareToPlatformType:(UMSocialPlatformType)platformType
{
    //    //创建分享消息对象
    //    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:self.shareInfo[@"title"] descr:self.shareInfo[@"description"] thumImage:self.shareInfo[@"thumbData"]];
    //    /* 低版本微信网页链接 */
    //    shareObject.webpageUrl = @"https://www.jianshu.com/p/c75ba7561011";//self.shareInfo[@"webpageUrl"]
    //    /* 小程序username */
    //    shareObject.userName = self.shareInfo[@"userName"];
    //    /* 小程序页面的路径 */
    //    shareObject.path = self.shareInfo[@"path"];
    //    /* 小程序新版本的预览图 128k */
    //    shareObject.hdImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareInfo[@"thumbData"]]];
    //    /* 分享小程序的版本（正式，开发，体验）*/
    //
    //    NSInteger miniprogramType = [self.shareInfo[@"miniprogramType"] integerValue];//正式版:0，测试版:1，体验版:2
    //    if (miniprogramType == 0) {
    //        shareObject.miniProgramType = UShareWXMiniProgramTypeRelease;
    //    }else if (miniprogramType == 1) {
    //        shareObject.miniProgramType = UShareWXMiniProgramTypeTest;
    //    }else{
    //        shareObject.miniProgramType = UShareWXMiniProgramTypePreview;
    //    }
    //    messageObject.shareObject = shareObject;
    //    //调用分享接口
    //    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
    //        if (error) {
    //            UMSocialLogInfo(@"************Share fail with error %@*********",error);
    //            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    //        }else{
    //            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
    //                UMSocialShareResponse *resp = data;
    //                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:resp.message];
    //                //分享结果消息
    //                UMSocialLogInfo(@"response message is %@",resp.message);
    //                //第三方原始返回的数据
    //                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
    //            }else{
    //                UMSocialLogInfo(@"response data is %@",data);
    //            }
    //        }
    //    }];
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
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    @try {
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
    @catch (NSException *exception) {
        HXLog(@"多次删除了");
    }
    @finally {
        HXLog(@"多次删除了");
    }
}
-(void)dealloc
{
    @try {
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
