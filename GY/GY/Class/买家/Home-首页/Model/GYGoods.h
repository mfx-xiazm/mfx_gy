//
//  GYGoods.h
//  GY
//
//  Created by 夏增明 on 2019/10/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GYGoodsDetail;
@interface GYGoods : NSObject
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *goods_type;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cate_id;
@property(nonatomic,copy) NSString *goods_no;
@property(nonatomic,copy) NSString *stock_num;
@property(nonatomic,copy) NSString *series_id;
@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *goods_model;
@property(nonatomic,copy) NSString *market_price;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *unit;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *goods_detail;
@property(nonatomic,copy) NSString *shelf_status;
@property(nonatomic,copy) NSString *shelf_time;
@property(nonatomic,copy) NSString *freight;
@property(nonatomic,copy) NSString *is_spec;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *goods_type_name;

/** 商品详情 */
@property(nonatomic,strong) GYGoodsDetail *goodsDetail;
@end

NS_ASSUME_NONNULL_END
