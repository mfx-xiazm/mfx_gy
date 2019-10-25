//
//  GYRegion.h
//  GY
//
//  Created by 夏增明 on 2019/10/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GYSubRegion;
@interface GYRegion : NSObject
@property(nonatomic,copy) NSString *cityid;
@property(nonatomic,copy) NSString *alias;
@property(nonatomic,strong) NSArray <GYSubRegion *> *city;
/* 选中的城市 */
@property(nonatomic,assign) GYSubRegion *selectRegion;
@end

@interface GYSubRegion : NSObject
@property(nonatomic,copy) NSString *cityid;
@property(nonatomic,copy) NSString *alias;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
