//
//  GYGoodsDetail.h
//  GY
//
//  Created by 夏增明 on 2019/10/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GYGoodAdv,GYGoodSpec,GYGoodSubSpec,GYGoodsComment,GYGoodsCommentLayout;
@interface GYGoodsDetail : NSObject
@property(nonatomic,copy)NSString *goods_id;
@property(nonatomic,copy)NSString *stock_num;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *goods_type;
@property(nonatomic,copy)NSString *goods_name;
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSString *goods_no;
@property(nonatomic,copy)NSString *series_id;
@property(nonatomic,copy)NSString *brand_id;
@property(nonatomic,copy)NSString *goods_model;
@property(nonatomic,copy)NSString *market_price;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *cover_img;
@property(nonatomic,copy)NSString *goods_detail;
@property(nonatomic,copy)NSString *shelf_status;
@property(nonatomic,copy)NSString *shelf_time;
@property(nonatomic,copy)NSString *freight;
@property(nonatomic,copy)NSString *is_spec;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *series_name;
@property(nonatomic,copy)NSString *brand_name;
@property(nonatomic,assign) BOOL collected;
@property(nonatomic,strong) NSArray<GYGoodAdv *> *good_adv;
@property(nonatomic,strong) NSArray<GYGoodSpec *> *spec;
@property(nonatomic,strong) GYGoodsComment *eva;
@property(nonatomic,strong) GYGoodsCommentLayout *evaLayout;
/** 购买的数量 */
@property(nonatomic,assign) NSInteger buyNum;

@end

@interface GYGoodAdv : NSObject

@property(nonatomic,copy)NSString *goods_adv_id;
@property(nonatomic,copy)NSString *goods_id;
@property(nonatomic,copy)NSString *adv_img;

@end

@interface GYGoodSpec : NSObject
@property(nonatomic,copy)NSString *spec_id;
@property(nonatomic,copy)NSString *spec_name;
@property(nonatomic,strong) NSArray<GYGoodSubSpec *> *spec_val;
/* 选中的改分区的那个规格 */
@property(nonatomic,strong) GYGoodSubSpec *selectSpec;
@end

@interface GYGoodSubSpec : NSObject
@property(nonatomic,copy)NSString *spec_value_id;
@property(nonatomic,copy)NSString *spec_value;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
