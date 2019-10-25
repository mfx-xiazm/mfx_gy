//
//  GYAuthInfoVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYAuthInfoVC.h"
#import "GYMineData.h"

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

@end
