//
//  GYEditAddressVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYEditAddressVC.h"

@interface GYEditAddressVC ()

@end

@implementation GYEditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"添加/编辑地址"];

    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    edit.hxn_size = CGSizeMake(50, 40);
    edit.titleLabel.font = [UIFont systemFontOfSize:13];
    [edit setTitle:@"保存" forState:UIControlStateNormal];
    [edit addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    [edit setTitleColor:UIColorFromRGB(0XFFFFFF) forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:edit];
}
-(void)saveClicked
{
    HXLog(@"保存");
}
@end
