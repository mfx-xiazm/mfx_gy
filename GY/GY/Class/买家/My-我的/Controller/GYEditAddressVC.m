//
//  GYEditAddressVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYEditAddressVC.h"
#import "GYConfirmOrder.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "ZJPickerView.h"

@interface GYEditAddressVC ()
@property (weak, nonatomic) IBOutlet UITextField *receiver;
@property (weak, nonatomic) IBOutlet UITextField *receiver_phone;
@property (weak, nonatomic) IBOutlet UITextField *area_name;
@property (weak, nonatomic) IBOutlet UITextField *address_detail;
@property (weak, nonatomic) IBOutlet UIButton *is_defalt;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
/* 地区id */
@property(nonatomic,copy) NSString *area_id;
@end

@implementation GYEditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    
    if (self.address) {
        self.receiver.text = _address.receiver;
        self.receiver_phone.text = _address.receiver_phone;
        self.area_name.text = _address.area_name;
        self.address_detail.text = _address.address_detail;
        self.is_defalt.selected = _address.is_default;
        self.area_id = _address.area_id;
        
        self.delBtn.hidden = NO;
    }else{
        self.delBtn.hidden = YES;
    }
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:self.address?@"编辑地址":@"添加地址"];

    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    edit.hxn_size = CGSizeMake(50, 40);
    edit.titleLabel.font = [UIFont systemFontOfSize:13];
    [edit setTitle:@"保存" forState:UIControlStateNormal];
    [edit addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    [edit setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:edit];
}
#pragma mark -- 点击事件
-(void)saveClicked
{
    if (![self.receiver hasText]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写收货人"];
        return ;
    }
    if (![self.receiver_phone hasText]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写收货人电话"];
        return ;
    }
    if (![self.area_name hasText]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择地区"];
        return ;
    }
    if (![self.address_detail hasText]) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写详细地址"];
        return ;
    }
    
    [self addEditAddressRequest];
}
- (IBAction)delAddressClicked:(UIButton *)sender {
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该地址吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
    hx_weakify(self);
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
    }];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismiss];
        [strongSelf delAddressRequest];
    }];
    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
    self.zh_popupController = [[zhPopupController alloc] init];
    [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
}
- (IBAction)chooseAreaClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    if (districtStr == nil) {
        return ;
    }
    NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *district = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *realArr = [NSMutableArray array];
    for (NSDictionary *Pro in (NSArray *)district[@"result"][@"list"]) {
        NSArray *sub = (NSArray *)Pro[@"city"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *subPro in sub) {
            NSMutableArray *tempArr1 = [NSMutableArray array];
            for (NSDictionary *trdPro in subPro[@"area"]) {
                [tempArr1 addObject:trdPro[@"alias"]];
            }
            [tempArr addObject:@{subPro[@"alias"]:tempArr1}];
        }
        [realArr addObject:@{Pro[@"alias"] : tempArr}];
    }
    [self showPickerViewWithDataList:realArr];
}
- (void)showPickerViewWithDataList:(NSArray *)dataList
{
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{
                                   ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
                                   ZJPickerViewPropertySureBtnTitleKey  : @"确定",
                                   ZJPickerViewPropertyTipLabelTextKey  : @"选择地区", // 提示内容
                                   ZJPickerViewPropertyCanceBtnTitleColorKey : UIColorFromRGB(0xA9A9A9),
                                   ZJPickerViewPropertySureBtnTitleColorKey : UIColorFromRGB(0x232323),
                                   ZJPickerViewPropertyTipLabelTextColorKey :
                                       UIColorFromRGB(0x131D2D),
                                   ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyPickerViewHeightKey : @260.0f,
                                   ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
                                   ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x131D2D), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0xA9A9A9), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                   ZJPickerViewPropertyIsShowSelectContentKey : @YES,
                                   ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
                                   ZJPickerViewPropertyIsAnimationShowKey : @YES};
    
    // 2.Show（显示）
    hx_weakify(self);
    [ZJPickerView zj_showWithDataList:dataList propertyDict:propertyDict completion:^(NSString *selectContent) {
        hx_strongify(weakSelf);
        // show select content|
        NSArray *results = [selectContent componentsSeparatedByString:@"|"];
        //        NSArray *selectStrings = [selectContent componentsSeparatedByString:@","];
        NSMutableString *selectStringCollection = [[NSMutableString alloc] init];
        [[results.firstObject componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString *selectString, NSUInteger idx, BOOL * _Nonnull stop) {
            if (selectString.length && ![selectString isEqualToString:@""]) {
                [selectStringCollection appendString:selectString];
            }
        }];
        strongSelf.area_name.text = selectStringCollection;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
        NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        
        if (districtStr == nil) {
            return ;
        }
        NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *district = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSArray *rows = [results.lastObject componentsSeparatedByString:@","];
        
        if (((NSArray *)district[@"result"][@"list"][[rows[0] integerValue]][@"city"][[rows[1] integerValue]][@"area"]).count) {
            strongSelf.area_id = district[@"result"][@"list"][[rows[0] integerValue]][@"city"][[rows[1] integerValue]][@"area"][[rows[2] integerValue]][@"id"];
        }else{
            strongSelf.area_id = district[@"result"][@"list"][[rows[0] integerValue]][@"city"][[rows[1] integerValue]][@"id"];
        }
    }];
}
- (IBAction)setDefaultClicked:(UIButton *)sender {
    self.is_defalt.selected = !self.is_defalt.selected;
}

#pragma mark -- 业务逻辑
-(void)addEditAddressRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"receiver"] = self.receiver.text;
    parameters[@"receiver_phone"] = self.receiver_phone.text;
    parameters[@"area_id"] = self.area_id;
    parameters[@"area_name"] = self.area_name.text;
    parameters[@"address_detail"] = self.address_detail.text;
    parameters[@"is_default"] = @(self.is_defalt.isSelected);
    if (self.address) {
        parameters[@"address_id"] = self.address.address_id;
    }
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:self.address?@"editAddress":@"addAddress" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.editSuccessCall) {
                strongSelf.editSuccessCall(strongSelf.address?2:1);
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)delAddressRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"address_id"] = self.address.address_id;//地址id
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"delAddress" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (strongSelf.editSuccessCall) {
                strongSelf.editSuccessCall(3);
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

@end
