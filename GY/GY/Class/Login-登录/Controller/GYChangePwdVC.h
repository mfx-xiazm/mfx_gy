//
//  GYChangePwdVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface GYChangePwdVC : HXBaseViewController
/* 类型 1忘记密码 2修改密码 */
@property(nonatomic,assign) NSInteger dataType;
/* 个人信息 */
@property(nonatomic,copy) NSString *phoneStr;
@end

NS_ASSUME_NONNULL_END
