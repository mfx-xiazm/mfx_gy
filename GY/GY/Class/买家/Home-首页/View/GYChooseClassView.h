//
//  GYChooseClassView.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYGoodsDetail;
typedef void(^goodsHandleCall)(NSInteger type);
@interface GYChooseClassView : UIView
/** 商品详情 */
@property(nonatomic,strong) GYGoodsDetail *goodsDetail;
/* 操作点击 */
@property(nonatomic,copy) goodsHandleCall goodsHandleCall;
@end

NS_ASSUME_NONNULL_END
