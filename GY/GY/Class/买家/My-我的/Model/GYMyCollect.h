//
//  GYMyCollect.h
//  GY
//
//  Created by 夏增明 on 2019/10/23.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYMyCollect : NSObject
@property(nonatomic,copy) NSString *collect_id;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_type;
@property(nonatomic,copy) NSString *goods_type_name;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *market_price;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *brand_img;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
