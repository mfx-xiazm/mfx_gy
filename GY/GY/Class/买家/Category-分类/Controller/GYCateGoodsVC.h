//
//  GYCateGoodsVC.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYCateGoodsVC : HXBaseViewController
/* 标题 */
@property(nonatomic,copy) NSString *navTitle;
/* 分类id */
@property(nonatomic,copy) NSString *cate_id;
/* 品牌id */
@property(nonatomic,copy) NSString *brand_id;
/* 数据类型 1分类 2品牌 3首页分区 */
@property(nonatomic,assign) NSInteger dataType;
@end

NS_ASSUME_NONNULL_END
