//
//  GYRegisterAuthVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYRegisterAuthVC.h"
#import "GYWebContentVC.h"
#import "FSActionSheet.h"
#import "zhAlertView.h"
#import "GYWorkCategoryView.h"
#import <zhPopupController.h>
#import "GYRegisterSuccessVC.h"
#import "GYWorkType.h"

@interface GYRegisterAuthVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *buyRoleView;
@property (weak, nonatomic) IBOutlet UIView *workManView;
@property (weak, nonatomic) IBOutlet UIImageView *licenseImg;
@property (weak, nonatomic) IBOutlet UIImageView *cardFrontImg;
@property (weak, nonatomic) IBOutlet UIImageView *cardBackImg;
@property (weak, nonatomic) IBOutlet UITextField *utypeName;
@property (weak, nonatomic) IBOutlet UITextField *et_name;
@property (weak, nonatomic) IBOutlet UITextField *user_name;
@property (weak, nonatomic) IBOutlet UITextField *user_name1;
@property (weak, nonatomic) IBOutlet UILabel *workTypesLabel;
/* 身份 1买家 3技工 */
@property(nonatomic,copy) NSString *utype;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
/* 营业执照链接 */
@property(nonatomic,copy) NSString *licenseImgUrl;
/* 正面链接 */
@property(nonatomic,copy) NSString *cardFrontImgUrl;
/* 反面链接 */
@property(nonatomic,copy) NSString *cardBackImgUrl;
/* 点击的图片tag */
@property(nonatomic,assign) NSInteger imgTag;
/* 技术工种 */
@property(nonatomic,strong) NSArray *workTypes;
/* 选择工种视图 */
@property(nonatomic,strong) GYWorkCategoryView *workTypeView;
@end

@implementation GYRegisterAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"认证信息"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(licenseTaped:)];
    [self.licenseImg addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(licenseTaped:)];
    [self.cardFrontImg addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(licenseTaped:)];
    [self.cardBackImg addGestureRecognizer:tap2];
    
    hx_weakify(self);
    [self.submitBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.utypeName hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择身份"];
            return NO;
        }
        if ([self.utype isEqualToString:@"1"]) {
            if (![strongSelf.et_name hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写企业名称"];
                return NO;
            }
            if (![strongSelf.user_name hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写姓名"];
                return NO;
            }
            if (!strongSelf.licenseImgUrl && !strongSelf.licenseImgUrl.length) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传营业执照"];
                return NO;
            }
        }else{
            if (![strongSelf.user_name1 hasText]) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写姓名"];
                return NO;
            }
            if (!strongSelf.workTypesLabel.text || !strongSelf.workTypesLabel.text.length) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择维修工种"];
                return NO;
            }
            if (!strongSelf.cardFrontImgUrl && !strongSelf.cardFrontImgUrl.length) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传身份证正面照"];
                return NO;
            }
            if (!strongSelf.cardBackImgUrl && !strongSelf.cardBackImgUrl.length) {
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传身份证反面照"];
                return NO;
            }
        }
        if (!strongSelf.agreeBtn.isSelected) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"未勾选注册协议"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf submitClicked:button];
    }];
}
-(GYWorkCategoryView *)workTypeView
{
    if (_workTypeView == nil) {
        _workTypeView = [GYWorkCategoryView loadXibView];
        _workTypeView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-30*2, 260);
    }
    return _workTypeView;
}
- (IBAction)agreeBtnClicked:(UIButton *)sender {
    self.agreeBtn.selected = !self.agreeBtn.isSelected;
}

- (IBAction)agreementClicked:(UIButton *)sender {
    GYWebContentVC *cvc = [GYWebContentVC new];
    cvc.navTitle = @"服务协议";
    cvc.requestType = 1;
    cvc.isNeedRequest = YES;
    cvc.type = (self.utype && self.utype.length)?self.utype:@"1";
    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)chooseRoleClicked:(UIButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"买家",@"技工"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            strongSelf.utype = @"1";
            strongSelf.buyRoleView.hidden = NO;
            strongSelf.workManView.hidden = YES;
            strongSelf.utypeName.text = @"买家";
        }else{
            strongSelf.utype = @"3";
            strongSelf.buyRoleView.hidden = YES;
            strongSelf.workManView.hidden = NO;
            strongSelf.utypeName.text = @"技工";
            if (!strongSelf.workTypes || !strongSelf.workTypes.count) {
                [strongSelf getWorkTypesRequest];
            }
        }
    }];
}
- (IBAction)chooseWorkCateClicked:(UIButton *)sender {
    self.workTypeView.workTypes = self.workTypes;
    hx_weakify(self);
    self.workTypeView.workCateCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (index == 1) {
            NSMutableString *workTypeStr = [NSMutableString string];
            for (GYWorkType *workType in strongSelf.workTypes) {
                if (workType.isSelected) {
                    if (workTypeStr.length) {
                        [workTypeStr appendFormat:@",%@",workType.set_val];
                    }else{
                        [workTypeStr appendFormat:@"%@",workType.set_val];
                    }
                }
            }
            strongSelf.workTypesLabel.text = workTypeStr;
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    [self.zh_popupController presentContentView:self.workTypeView duration:0.25 springAnimated:NO];
}

- (void)submitClicked:(UIButton *)sender {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.phone;//手机号
    parameters[@"pwd"] = self.pwd;//密码
    parameters[@"utype"] = self.utype;//为1表示注册为买家;为3表示注册为技工
    parameters[@"et_name"] = [self.utype isEqualToString:@"1"]?self.et_name.text:@"";//买家企业名称 如果是买家则需填写该字段如果是技工 该字段可为空
    parameters[@"user_name"] = [self.utype isEqualToString:@"1"]?self.user_name.text:self.user_name1.text;//买家或技工用户名
    parameters[@"attach_img1"] = [self.utype isEqualToString:@"1"]?self.licenseImgUrl:self.cardFrontImgUrl;//如果注册的身份是 买家 则只需要传递营业执照即attach_img1如果注册的身份是技工 则该字段为技工身份证正面
    parameters[@"attach_img2"] = [self.utype isEqualToString:@"1"]?@"":self.cardBackImgUrl;//身份证反面
    parameters[@"work_types"] = [self.utype isEqualToString:@"1"]?@"":self.workTypesLabel.text;//工种1,工种2 技工工种，多个全角逗号“，”分隔。买家和经销商为空
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"register" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [sender stopLoading:@"提交审核" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] boolValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                GYRegisterSuccessVC *svc = [GYRegisterSuccessVC new];
                [strongSelf presentViewController:svc animated:YES completion:nil];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [sender stopLoading:@"提交审核" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

-(void)licenseTaped:(UITapGestureRecognizer *)tap
{
    self.imgTag = tap.view.tag;
    
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            [strongSelf awakeImagePickerController:@"1"];
        }else{
            [strongSelf awakeImagePickerController:@"2"];
        }
    }];
}
#pragma mark -- 唤起相机
- (void)awakeImagePickerController:(NSString *)pickerType {
    if ([pickerType isEqualToString:@"1"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            if ([self isCanUseCamera]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相机不可用"];
            return;
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            if ([self isCanUsePhotos]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //前后摄像头是否可用
                [UIImagePickerController isCameraDeviceAvailable:YES];
                //相机闪光灯是否OK
                [UIImagePickerController isFlashAvailableForCameraDevice:YES];
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }else{
                hx_weakify(self);
                zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" constantWidth:HX_SCREEN_WIDTH - 50*2];
                zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"知道了" handler:^(zhAlertButton * _Nonnull button) {
                    hx_strongify(weakSelf);
                    [strongSelf.zh_popupController dismiss];
                }];
                okButton.lineColor = UIColorFromRGB(0xDDDDDD);
                [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
                [alert addAction:okButton];
                self.zh_popupController = [[zhPopupController alloc] init];
                [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
            }
        }else{
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionTop title:@"相册不可用"];
            return;
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    hx_weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        hx_strongify(weakSelf);
        // 显示保存图片
        [strongSelf upImageRequestWithImage:info[UIImagePickerControllerEditedImage] completedCall:^(NSString *imageUrl,NSString * imagePath) {
            if (strongSelf.imgTag == 1) {
                [strongSelf.licenseImg sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.licenseImgUrl = imageUrl;
            }else if (strongSelf.imgTag == 2) {
                [strongSelf.cardFrontImg sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.cardFrontImgUrl = imageUrl;
            }else{
                [strongSelf.cardBackImg sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                strongSelf.cardBackImgUrl = imageUrl;
            }
        }];
    }];
}
-(void)upImageRequestWithImage:(UIImage *)image completedCall:(void(^)(NSString * imageUrl,NSString * imagePath))completedCall
{
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"uploadFile" parameters:@{} name:@"file" images:@[image] fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] boolValue]) {
            completedCall(responseObject[@"data"][@"path"],responseObject[@"data"][@"imgPath"]);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)getWorkTypesRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getWorkTypeData" parameters:nil success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] boolValue]) {
            strongSelf.workTypes = [NSArray yy_modelArrayWithClass:[GYWorkType class] json:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}

@end
