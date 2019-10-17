//
//  GYRegisterVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYRegisterVC.h"
#import "GYRegisterAuthVC.h"

@interface GYRegisterVC ()

@end

@implementation GYRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"注册"];
}
- (IBAction)nextBtnClicked:(UIButton *)sender {
    GYRegisterAuthVC *avc = [GYRegisterAuthVC new];
    [self.navigationController pushViewController:avc animated:YES];
}


@end
