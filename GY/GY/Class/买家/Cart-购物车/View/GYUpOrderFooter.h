//
//  GYUpOrderFooter.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYUserInvoice;
typedef void(^faPiaoClickedCall)(void);
@interface GYUpOrderFooter : UIView
@property (weak, nonatomic) IBOutlet UIButton *openPiao;
/* 点击 */
@property(nonatomic,copy) faPiaoClickedCall faPiaoClickedCall;
/* 发票 */
@property(nonatomic,strong) GYUserInvoice *userInvoice;
@end

NS_ASSUME_NONNULL_END
