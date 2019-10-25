//
//  GYMyTaskDetail.h
//  GY
//
//  Created by 夏增明 on 2019/10/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYMyTaskDetail : NSObject
@property(nonatomic,copy) NSString *uid;
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
@property(nonatomic,copy) NSString *task_content;

@property(nonatomic,copy) NSString *user_name;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *work_types;
@property(nonatomic,copy) NSString *contact_name;
@property(nonatomic,copy) NSString *contact_phone;
@property(nonatomic,strong) NSArray *taskImgs;

@end

NS_ASSUME_NONNULL_END
