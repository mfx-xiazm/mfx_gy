//
//  GYMyRefund.h
//  GY
//
//  Created by 夏增明 on 2019/10/23.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GYMyRefundGoods;
@interface GYMyRefund : NSObject
@property(nonatomic,copy) NSString *refund_id;
@property(nonatomic,copy) NSString *oid;
/* 1等待经销商审核 2等待平台审核 3退款成功 4退款驳回 5经销商同意 5经销商不同意*/
@property(nonatomic,copy) NSString *refund_status;
@property(nonatomic,copy) NSString *refund_img;
@property(nonatomic,copy) NSString *refund_time;
@property(nonatomic,copy) NSString *order_no;
@property(nonatomic,copy) NSString *pay_amount;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *goods_num;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *spec_values;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *goods_type;
@property(nonatomic,copy) NSString *market_price;

@property(nonatomic,copy) NSString *pay_type;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *pay_time;
@property(nonatomic,copy) NSString *order_freight_amount;
@property(nonatomic,copy) NSString *order_price_amount;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *reject_reason;
@property(nonatomic,copy) NSString *logistics_com_id;
@property(nonatomic,copy) NSString *logistics_no;
@property(nonatomic,copy) NSString *logistics_com_name;
@property(nonatomic,copy) NSString *receiver;
@property(nonatomic,copy) NSString *receiver_phone;
@property(nonatomic,copy) NSString *area_name;
@property(nonatomic,copy) NSString *address_detail;
@property(nonatomic,copy) NSString *trade_no;
@property(nonatomic,copy) NSString *invoice_id;
@property(nonatomic,copy) NSString *et_name;
@property(nonatomic,copy) NSString *organ_code;
@property(nonatomic,copy) NSString *register_address;
@property(nonatomic,copy) NSString *contact_phone;
@property(nonatomic,copy) NSString *open_bank;
@property(nonatomic,copy) NSString *receive_address;
@property(nonatomic,copy) NSString *invoice_receive;
@property(nonatomic,copy) NSString *receive_phone;
@property(nonatomic,copy) NSString *account;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *logistics_title;

@property(nonatomic,strong) NSArray<GYMyRefundGoods *> *goods;

@end

@interface GYMyRefundGoods : NSObject
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *goods_num;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *goods_type;
@property(nonatomic,copy) NSString *spec_values;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *market_price;
@property(nonatomic,copy) NSString *price_amount;
@property(nonatomic,copy) NSString *order_note;
@property(nonatomic,copy) NSString *freight;
@property(nonatomic,copy) NSString *freight_amount;
@property(nonatomic,copy) NSString *totalPrice;
@property(nonatomic,copy) NSString *shelf_status;

@end

NS_ASSUME_NONNULL_END
