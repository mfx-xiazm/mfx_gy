//
//  GYCartData.h
//  GY
//
//  Created by 夏增明 on 2019/10/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYCartData : NSObject
@property(nonatomic,copy) NSString *cart_id;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *goods_type;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *market_price;
@property(nonatomic,copy) NSString *freight;
@property(nonatomic,copy) NSString *stock_num;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *brand_id;
@property(nonatomic,copy) NSString *cart_num;
@property(nonatomic,copy) NSString *spec_values;
@property(nonatomic,copy) NSString *brand_name;
@property(nonatomic,copy) NSString *brand_img;

@property(nonatomic,assign) BOOL is_checked;
@end

NS_ASSUME_NONNULL_END
