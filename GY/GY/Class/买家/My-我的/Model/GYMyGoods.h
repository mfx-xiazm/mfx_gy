//
//  GYMyGoods.h
//  GY
//
//  Created by 夏增明 on 2019/10/23.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYMyGoods : NSObject
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *stock_num;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *market_price;
@property(nonatomic,copy) NSString *goods_type;
@property(nonatomic,copy) NSString *brand_img;
@property(nonatomic,copy) NSString *shelf_status;
@end

NS_ASSUME_NONNULL_END
