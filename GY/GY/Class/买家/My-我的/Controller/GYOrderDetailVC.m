//
//  GYOrderDetailVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYOrderDetailVC.h"
#import "GYOrderDetailHeader.h"
#import "GYOrderDetailCell.h"
#import "GYOrderDetailFooter.h"
#import "GYInvoiceDetailFooter.h"
#import "GYEvaluateVC.h"
#import "GYMyOrder.h"
#import "GYOrderPay.h"
#import "GYPayTypeView.h"
#import <zhPopupController.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "zhAlertView.h"
#import "GYMyRefund.h"
#import "GYWebContentVC.h"

static NSString *const OrderDetailCell = @"OrderDetailCell";
@interface GYOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) GYOrderDetailHeader *header;
/* 尾视图 */
@property(nonatomic,strong) GYInvoiceDetailFooter *footer;
/* 订单详情 */
@property(nonatomic,strong) GYMyOrder *orderDetail;
/* 退款订单详情 */
@property(nonatomic,strong) GYMyRefund *refundDetail;
/* 订单操作视图 */
@property (weak, nonatomic) IBOutlet UIView *handleView;
/* 订单操作视图高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleViewHeight;
/* 订单操作第一个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *firstHandleBtn;
/* 订单操作第二个按钮 */
@property (weak, nonatomic) IBOutlet UIButton *secpngHandleBtn;
@end

@implementation GYOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPayPush:) name:HXPayPushNotification object:nil];
    [self setUpTableView];
    [self startShimmer];
    [self getOrderInfoRequest];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 225);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 290);
}
-(GYOrderDetailHeader *)header
{
    if (_header == nil) {
        _header = [GYOrderDetailHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 225);
    }
    return _header;
}
-(GYInvoiceDetailFooter*)footer
{
    if (_footer == nil) {
        _footer = [GYInvoiceDetailFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 290);
    }
    return _footer;
}
-(void)setUpTableView
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 180.f;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYOrderDetailCell class]) bundle:nil] forCellReuseIdentifier:OrderDetailCell];
    
    self.tableView.tableHeaderView = self.header;
    
    self.tableView.hidden = YES;
}
#pragma mark -- 接口请求
-(void)getOrderInfoRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.refund_id && self.refund_id.length) {
        parameters[@"refund_id"] = self.refund_id;
    }else{
        parameters[@"oid"] = self.oid;
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:(self.refund_id && self.refund_id.length)?@"orderRefundInfo":@"getOrderInfo" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.refund_id && strongSelf.refund_id.length) {
                strongSelf.refundDetail = [GYMyRefund yy_modelWithDictionary:responseObject[@"data"]];
            }else{
                strongSelf.orderDetail = [GYMyOrder yy_modelWithDictionary:responseObject[@"data"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleOrderDetailData];
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
-(void)handleOrderDetailData
{
    self.tableView.hidden = NO;
    
    if (self.refund_id && self.refund_id.length) {
        self.handleView.hidden = YES;
        self.handleViewHeight.constant = 0.f;
        self.firstHandleBtn.hidden = YES;
        self.secpngHandleBtn.hidden = YES;
        
        self.header.refundDetail = self.refundDetail;
        hx_weakify(self);
        self.header.lookLogisCall = ^{
            hx_strongify(weakSelf);
            //HXLog(@"查看物流");
            GYWebContentVC *cvc = [GYWebContentVC new];
            cvc.navTitle = @"物流详情";
            cvc.isNeedRequest = NO;
            cvc.url = strongSelf.refundDetail.url;
            [strongSelf.navigationController pushViewController:cvc animated:YES];
        };
        
        if (self.refundDetail.invoice_id && self.refundDetail.invoice_id.length && [self.refundDetail.invoice_id integerValue] != 0) {//存在发票信息
            self.footer.refundDetail = self.refundDetail;
            self.tableView.tableFooterView = self.footer;
        }
        
    }else{
        if ([MSUserManager sharedInstance].curUserInfo.utype == 1) {//买家
            if ([self.orderDetail.approve_status isEqualToString:@"2"]) {//订单审核通过
                if ([self.orderDetail.status isEqualToString:@"已完成"] || [self.orderDetail.status isEqualToString:@"已取消"]) {
                    self.handleView.hidden = YES;
                    self.handleViewHeight.constant = 0.f;
                }else{
                    self.handleView.hidden = NO;
                    self.handleViewHeight.constant = 50.f;
                    
                    if ([self.orderDetail.status isEqualToString:@"待付款"]) {
                        self.firstHandleBtn.hidden = NO;
                        [self.firstHandleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                        self.firstHandleBtn.backgroundColor = [UIColor whiteColor];
                        self.firstHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                        [self.firstHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        
                        self.secpngHandleBtn.hidden = NO;
                        [self.secpngHandleBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                        self.secpngHandleBtn.backgroundColor = UIColorFromRGB(0xFF4D4D);
                        self.secpngHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
                        [self.secpngHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        
                    }else if ([self.orderDetail.status isEqualToString:@"待发货"]) {
                        self.firstHandleBtn.hidden = YES;
                        
                        self.secpngHandleBtn.hidden = NO;
                        [self.secpngHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                        self.secpngHandleBtn.backgroundColor = [UIColor whiteColor];
                        self.secpngHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                        [self.secpngHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        
                    }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
                        self.firstHandleBtn.hidden = NO;
                        [self.firstHandleBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                        self.firstHandleBtn.backgroundColor = [UIColor whiteColor];
                        self.firstHandleBtn.layer.borderColor = [UIColor blackColor].CGColor;
                        [self.firstHandleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        
                        self.secpngHandleBtn.hidden = NO;
                        [self.secpngHandleBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                        self.secpngHandleBtn.backgroundColor = UIColorFromRGB(0xFF4D4D);
                        self.secpngHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
                        [self.secpngHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }else if ([self.orderDetail.status isEqualToString:@"待评价"]) {
                        self.firstHandleBtn.hidden = YES;
                        
                        self.secpngHandleBtn.hidden = NO;
                        [self.secpngHandleBtn setTitle:@"评价" forState:UIControlStateNormal];
                        self.secpngHandleBtn.backgroundColor = UIColorFromRGB(0xFF4D4D);
                        self.secpngHandleBtn.layer.borderColor = [UIColor clearColor].CGColor;
                        [self.secpngHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }else{
                        self.firstHandleBtn.hidden = YES;
                        
                        self.secpngHandleBtn.hidden = YES;
                    }
                }
            }else{
                self.handleView.hidden = YES;
                self.handleViewHeight.constant = 0.f;
                self.firstHandleBtn.hidden = YES;
                self.secpngHandleBtn.hidden = YES;
            }
        }else{
            self.handleView.hidden = YES;
            self.handleViewHeight.constant = 0.f;
            self.firstHandleBtn.hidden = YES;
            self.secpngHandleBtn.hidden = YES;
        }
        self.header.orderDetail = self.orderDetail;
        hx_weakify(self);
        self.header.lookLogisCall = ^{
            hx_strongify(weakSelf);
            //HXLog(@"查看物流");
            GYWebContentVC *cvc = [GYWebContentVC new];
            cvc.navTitle = @"物流详情";
            cvc.isNeedRequest = NO;
            cvc.url = strongSelf.orderDetail.url;
            [strongSelf.navigationController pushViewController:cvc animated:YES];
        };
        
        if (self.orderDetail.invoice_id && self.orderDetail.invoice_id.length && [self.orderDetail.invoice_id integerValue] != 0) {//存在发票信息
            self.footer.orderDetail = self.orderDetail;
            self.tableView.tableFooterView = self.footer;
        }
    }
    
    [self.tableView reloadData];
}
#pragma mark -- 点击事件
- (IBAction)orderHandleBtnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        if ([self.orderDetail.status isEqualToString:@"待付款"]) {
            //HXLog(@"取消订单");
            [self cancelOrderRequest];
        }else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
            //HXLog(@"申请退款");
            [self orderRefundRequest];
        }
    }else{
        if ([self.orderDetail.status isEqualToString:@"待付款"]) {
            //HXLog(@"立即支付");
            self.orderPay.order_no = self.orderDetail.order_no;
            self.orderPay.pay_amount = self.orderDetail.pay_amount;
            [self showPayTypeView];
        }else if ([self.orderDetail.status isEqualToString:@"待发货"]) {
            //HXLog(@"申请退款");
            [self orderRefundRequest];
        } else if ([self.orderDetail.status isEqualToString:@"待收货"]) {
            //HXLog(@"确认收货");
            hx_weakify(self);
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要确认收货吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
            }];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"确认" handler:^(zhAlertButton * _Nonnull button) {
                hx_strongify(weakSelf);
                [strongSelf.zh_popupController dismiss];
                [strongSelf confirmReceiveGoodRequest];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
            self.zh_popupController = [[zhPopupController alloc] init];
            [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
        }else if ([self.orderDetail.status isEqualToString:@"待评价"]) {
            GYEvaluateVC *evc = [GYEvaluateVC new];
            evc.oid = self.oid;
            hx_weakify(self);
            evc.evaluatSuccessCall = ^{
                hx_strongify(weakSelf);
                if (strongSelf.orderHandleCall) {
                    strongSelf.orderHandleCall(4);
                }
            };
            [self.navigationController pushViewController:evc animated:YES];
        }
    }
}
#pragma mark -- 业务逻辑
/** 申请退款 */
-(void)orderRefundRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"orderRefund" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.refund_id = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            if (strongSelf.orderHandleCall) {
                strongSelf.orderHandleCall(2);
            }
            [strongSelf getOrderInfoRequest];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 取消订单 */
-(void)cancelOrderRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cancelOrder" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.orderHandleCall) {
                strongSelf.orderHandleCall(0);
            }
            [strongSelf getOrderInfoRequest];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 确认收货 */
-(void)confirmReceiveGoodRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oid"] = self.oid;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"confirmReceiveGood" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.orderHandleCall) {
                strongSelf.orderHandleCall(3);
            }
            [strongSelf getOrderInfoRequest];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- 调起支付
-(void)showPayTypeView
{
    GYPayTypeView *payType = [GYPayTypeView loadXibView];
    payType.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 345.f);
    payType.orderPay = self.orderPay;
    hx_weakify(self);
    payType.confirmPayCall = ^(NSInteger type) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        [strongSelf orderPayRequest:type];
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:payType duration:0.25 springAnimated:NO];
}
// 拉取支付信息
-(void)orderPayRequest:(NSInteger)type
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"order_no"] = self.orderPay.order_no;//商品订单id
    parameters[@"pay_type"] = @(type);//支付方式：1支付宝；2微信支付；3线下支付(后台审核)

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"orderPay" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            //pay_type 支付方式：1支付宝；2微信支付；3线下支付(后台审核)
            if (type == 1) {
                [strongSelf doAliPay:responseObject[@"data"]];
            }else if (type == 2){
                [strongSelf doWXPay:[responseObject[@"data"] dictionaryWithJsonString]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
                if (strongSelf.orderHandleCall) {
                    strongSelf.orderHandleCall(1);
                }
                [strongSelf getOrderInfoRequest];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
// 支付宝支付
-(void)doAliPay:(NSString *)parameters
{
    NSString *appScheme = @"GYAliPay";
    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = parameters;
    
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] intValue] == 9000) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付成功"];
        }else if ([resultDic[@"resultStatus"] intValue] == 6001){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"用户中途取消"];
        }else if ([resultDic[@"resultStatus"] intValue] == 6002){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"网络连接出错"];
        }else if ([resultDic[@"resultStatus"] intValue] == 4000){
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"订单支付失败"];
        }
    }];
}
// 微信支付
-(void)doWXPay:(NSDictionary *)dict
{
    if([WXApi isWXAppInstalled]) { // 判断 用户是否安装微信
        
        //需要创建这个支付对象
        PayReq *req   = [[PayReq alloc] init];
        //由用户微信号和AppID组成的唯一标识，用于校验微信用户
        req.openID = dict[@"appid"];
        
        // 商家id，在注册的时候给的
        req.partnerId = dict[@"partnerid"];
        
        // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
        req.prepayId  = dict[@"prepayid"];
        
        // 根据财付通文档填写的数据和签名
        //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
        req.package   = dict[@"package"];
        
        // 随机编码，为了防止重复的，在后台生成
        req.nonceStr  = dict[@"noncestr"];
        
        // 这个是时间戳，也是在后台生成的，为了验证支付的
        req.timeStamp = [dict[@"timestamp"] intValue];
        
        // 这个签名也是后台做的
        req.sign = dict[@"sign"];
        
        //发送请求到微信，等待微信返回onResp
        [WXApi sendReq:req];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"未安装微信"];
    }
}
#pragma mark -- 支付回调处理
-(void)doPayPush:(NSNotification *)note
{
    if ([note.userInfo[@"result"] isEqualToString:@"1"]) {//支付成功
        //1成功 2取消支付 3支付失败
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付成功"];
        if (self.orderHandleCall) {
            self.orderHandleCall(1);
        }
        [self getOrderInfoRequest];
    }else if([note.userInfo[@"result"] isEqualToString:@"2"]){
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"取消支付"];
    }else{
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"支付失败"];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.refund_id && self.refund_id.length) {
        return self.refundDetail.goods.count;
    }else{
        return self.orderDetail.goods.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderDetailCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.refund_id && self.refund_id.length) {
        GYMyRefundGoods *refundGoods = self.refundDetail.goods[indexPath.row];
        cell.refundGoods = refundGoods;
    }else{
        GYMyOrderGoods *goods = self.orderDetail.goods[indexPath.row];
        cell.goods = goods;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.refund_id && self.refund_id.length) {
        return 195.f;
    }else{
        if ([self.orderDetail.status isEqualToString:@"已取消"] || [self.orderDetail.status isEqualToString:@"待付款"]) {
            return 150.f;
        }else{
            return 195.f;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GYOrderDetailFooter *footer = [GYOrderDetailFooter loadXibView];
    if (self.refund_id && self.refund_id.length) {
        footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 195.f);
        footer.refundDetail = self.refundDetail;
    }else{
        if ([self.orderDetail.status isEqualToString:@"已取消"] || [self.orderDetail.status isEqualToString:@"待付款"]) {
            footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 150.f);
        }else{
            footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 195.f);
        }
        footer.orderDetail = self.orderDetail;
    }
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
