//
//  GYMyTasks.h
//  GY
//
//  Created by 夏增明 on 2019/10/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYMyTasks : NSObject
@property(nonatomic,copy) NSString *task_id;
@property(nonatomic,copy) NSString *task_no;
@property(nonatomic,copy) NSString *task_title;
@property(nonatomic,copy) NSString *task_type;
@property(nonatomic,copy) NSString *task_price;
@property(nonatomic,copy) NSString *task_date;
@property(nonatomic,copy) NSString *task_time;
@property(nonatomic,copy) NSString *city_id;
@property(nonatomic,copy) NSString *city_name;
@property(nonatomic,copy) NSString *province_name;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *task_img;
@property(nonatomic,copy) NSString *task_status;
@property(nonatomic,copy) NSString *create_time;

@end

NS_ASSUME_NONNULL_END
