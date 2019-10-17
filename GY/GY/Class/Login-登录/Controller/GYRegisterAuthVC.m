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

@interface GYRegisterAuthVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *buyRoleView;
@property (weak, nonatomic) IBOutlet UIView *workManView;
@property (weak, nonatomic) IBOutlet UIImageView *licenseImg;
@property (weak, nonatomic) IBOutlet UIImageView *cardFrontImg;
@property (weak, nonatomic) IBOutlet UIImageView *cardBackImg;

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
}
- (IBAction)agreementClicked:(UIButton *)sender {
    GYWebContentVC *cvc = [GYWebContentVC new];
    cvc.navTitle = @"服务协议";
    cvc.url = @"https://www.baidu.com/";
    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)chooseRoleClicked:(UIButton *)sender {
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"买家",@"技工"]];
    hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        hx_strongify(weakSelf);
        if (selectedIndex == 0) {
            strongSelf.buyRoleView.hidden = NO;
            strongSelf.workManView.hidden = YES;
        }else{
            strongSelf.buyRoleView.hidden = YES;
            strongSelf.workManView.hidden = NO;
        }
    }];
}
- (IBAction)chooseWorkCateClicked:(UIButton *)sender {
    GYWorkCategoryView *vc = [GYWorkCategoryView loadXibView];
    vc.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-30*2, 260);
    
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    [self.zh_popupController presentContentView:vc duration:0.25 springAnimated:NO];
}

- (IBAction)submitClicked:(UIButton *)sender {
    GYRegisterSuccessVC *svc = [GYRegisterSuccessVC new];
    [self presentViewController:svc animated:YES completion:nil];
}

-(void)licenseTaped:(UITapGestureRecognizer *)tap
{
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
//    hx_weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
//        hx_strongify(weakSelf);
//        // 显示保存图片
//        [strongSelf upImageRequestWithImage:info[UIImagePickerControllerEditedImage] completedCall:^(NSString *imageUrl) {
//            [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.headpic = imageUrl;
//            [[MSUserManager sharedInstance] saveUserInfo];
//            [strongSelf.header.headImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
//            [strongSelf updateUserPhotoRequest:imageUrl];
//        }];
    }];
}
@end
