//
//  GYSeries.h
//  GY
//
//  Created by 夏增明 on 2019/10/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYSeries : NSObject
@property(nonatomic,copy) NSString *series_id;
@property(nonatomic,copy) NSString *series_name;
@property(nonatomic,copy) NSString *create_time;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
