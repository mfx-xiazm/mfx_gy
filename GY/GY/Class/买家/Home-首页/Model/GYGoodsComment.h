//
//  GYGoodsComment.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYGoodsComment : NSObject
/** 内容文本 */
@property(nonatomic,copy)NSString *dsp;
/** 用户昵称 */
@property(nonatomic,copy)NSString *nick;
/** 用户头像 */
@property(nonatomic,copy)NSString *portrait;
/** 时间 */
@property(nonatomic,copy)NSString *creatTime;
/** 照片数组 */
@property(nonatomic,strong)NSArray *photos;

@property(nonatomic,copy)NSString *evl_id;
@property(nonatomic,copy)NSString *evl_level;
@property(nonatomic,copy)NSString *evl_content;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *nick_name;
@property(nonatomic,strong)NSArray *evaImgData;

/** 是否已展开文字 */
@property (nonatomic, assign) BOOL isOpening;
/** 是否应该显示"全文" */
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
@end

NS_ASSUME_NONNULL_END
