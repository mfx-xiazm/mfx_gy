//
//  GYAuthInfoVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYAuthInfoVC.h"

@interface GYAuthInfoVC ()
@property (weak, nonatomic) IBOutlet UIView *buyRoleView;
@property (weak, nonatomic) IBOutlet UIView *workRoleView;

@end

@implementation GYAuthInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"认证信息"];
}

@end
