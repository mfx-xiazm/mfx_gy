//
//  GYConfirmOrder.h
//  GY
//
//  Created by 夏增明 on 2019/10/21.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GYConfirmAddress,GYUserInvoice,GYConfirmGoodsDetail,GYConfirmGoods;
@interface GYConfirmOrder : NSObject
/* 地址 */
@property(nonatomic,strong) GYConfirmAddress *defaultAddress;
/* 发票 */
@property(nonatomic,strong) GYUserInvoice *userInvoice;
/* 确认的商品 */
@property(nonatomic,strong) GYConfirmGoods *goodsData;
@end

@interface GYConfirmAddress : NSObject
@property(nonatomic,copy) NSString *address_id;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *receiver;
@property(nonatomic,copy) NSString *receiver_phone;
@property(nonatomic,copy) NSString *area_id;
@property(nonatomic,copy) NSString *area_name;
@property(nonatomic,copy) NSString *address_detail;
@property(nonatomic,assign) BOOL is_default;
@property(nonatomic,copy) NSString *create_time;

@end

@interface GYUserInvoice : NSObject
@property(nonatomic,copy) NSString *user_invoice_id;
@property(nonatomic,copy) NSString *et_name;
@property(nonatomic,copy) NSString *organ_code;
@property(nonatomic,copy) NSString *register_address;
@property(nonatomic,copy) NSString *contact_phone;
@property(nonatomic,copy) NSString *open_bank;
@property(nonatomic,copy) NSString *receive_address;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *receiver;
@property(nonatomic,copy) NSString *receive_phone;
@property(nonatomic,copy) NSString *account;

@end

@interface GYConfirmGoods : NSObject
@property(nonatomic,copy) NSString *totalPayAmount;
@property(nonatomic,copy) NSString *order_freight_amount;
@property(nonatomic,copy) NSString *order_price_amount;
@property(nonatomic,strong) NSArray<GYConfirmGoodsDetail *> *goodsDetail;
@end

@interface GYConfirmGoodsDetail : NSObject
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *stock_num;
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *goods_type;
@property(nonatomic,copy) NSString *goods_type_name;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *market_price;
@property(nonatomic,copy) NSString *freight;
@property(nonatomic,copy) NSString *cart_num;
@property(nonatomic,copy) NSString *spec_values;
@property(nonatomic,copy) NSString *totalFreight;
@property(nonatomic,copy) NSString *totalPrice;
@property(nonatomic,copy) NSString *totalNum;

@property(nonatomic,copy) NSString *remark;// 备注
@end

NS_ASSUME_NONNULL_END
