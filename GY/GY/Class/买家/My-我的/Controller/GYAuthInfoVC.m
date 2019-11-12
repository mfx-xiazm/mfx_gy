//
//  GYAuthInfoVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYAuthInfoVC.h"
#import "GYMineData.h"
#import <ZLPhotoActionSheet.h>

@interface GYAuthInfoVC ()
@property (weak, nonatomic) IBOutlet UIView *buyRoleView;
@property (weak, nonatomic) IBOutlet UILabel *et_name;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UIImageView *lince_img;

@property (weak, nonatomic) IBOutlet UIView *workRoleView;
@property (weak, nonatomic) IBOutlet UILabel *user_name1;
@property (weak, nonatomic) IBOutlet UILabel *work_type;
@property (weak, nonatomic) IBOutlet UIImageView *fornt_img;
@property (weak, nonatomic) IBOutlet UIImageView *back_img;

@end

@implementation GYAuthInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"认证信息"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClicked:)];
    [self.lince_img addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClicked:)];
    [self.fornt_img addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClicked:)];
    [self.back_img addGestureRecognizer:tap2];
    
    if ([self.mineData.utype isEqualToString:@"1"]) {// 买家
        self.buyRoleView.hidden = NO;
        self.workRoleView.hidden = YES;
        self.et_name.text = self.mineData.et_name;
        self.user_name.text = self.mineData.user_name;
        [self.lince_img sd_setImageWithURL:[NSURL URLWithString:self.mineData.attach_img1]];
    }else{
        self.buyRoleView.hidden = YES;
        self.workRoleView.hidden = NO;
        self.user_name1.text = self.mineData.user_name;
        self.work_type.text = self.mineData.work_types;
        [self.fornt_img sd_setImageWithURL:[NSURL URLWithString:self.mineData.attach_img1]];
        [self.back_img sd_setImageWithURL:[NSURL URLWithString:self.mineData.attach_img2]];
    }
}
-(void)imgTapClicked:(UITapGestureRecognizer *)tap
{
    if ([self.mineData.utype isEqualToString:@"1"]) {// 买家
        NSMutableArray * items = [NSMutableArray array];
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        temp[@"ZLPreviewPhotoObj"] = [NSURL URLWithString:self.mineData.attach_img1];
        temp[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp];
        
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        actionSheet.configuration.navBarColor = HXControlBg;
        actionSheet.configuration.statusBarStyle = UIStatusBarStyleLightContent;
        actionSheet.sender = self;
        [actionSheet previewPhotos:items index:tap.view.tag hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
            
        }];
    }else{
        NSMutableArray * items = [NSMutableArray array];
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        temp[@"ZLPreviewPhotoObj"] = [NSURL URLWithString:self.mineData.attach_img1];
        temp[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp];
        
        NSMutableDictionary *temp1 = [NSMutableDictionary dictionary];
        temp1[@"ZLPreviewPhotoObj"] = [NSURL URLWithString:self.mineData.attach_img2];
        temp1[@"ZLPreviewPhotoTyp"] = @(ZLPreviewPhotoTypeURLImage);
        [items addObject:temp1];
        
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        actionSheet.configuration.navBarColor = HXControlBg;
        actionSheet.configuration.statusBarStyle = UIStatusBarStyleLightContent;
        actionSheet.sender = self;
        [actionSheet previewPhotos:items index:tap.view.tag hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
            
        }];
    }
}


@end
