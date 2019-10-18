//
//  GYWebContentVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYWebContentVC : HXBaseViewController
/** url */
@property (nonatomic,copy) NSString *url;
/** 标题 */
@property(nonatomic,copy) NSString *navTitle;
/** 是否需要请求 */
@property(nonatomic,assign) BOOL isNeedRequest;
/** 1注册协议 */
@property(nonatomic,assign) NSInteger requestType;
/** 注册协议 1买家 3技工 */
@property(nonatomic,copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
