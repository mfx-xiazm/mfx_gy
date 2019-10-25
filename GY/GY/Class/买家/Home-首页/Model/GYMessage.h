//
//  GYMessage.h
//  GY
//
//  Created by 夏增明 on 2019/10/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYMessage : NSObject
@property(nonatomic,copy) NSString *msg_id;
@property(nonatomic,copy) NSString *msg_content;
@property(nonatomic,assign) BOOL is_read;
@property(nonatomic,copy) NSString *ref_id;
/** 1订单详情 2发布需求接单详情 3退款订单详情 */
@property(nonatomic,copy) NSString *ref_type;
@property(nonatomic,copy) NSString *create_time;

@end

NS_ASSUME_NONNULL_END
