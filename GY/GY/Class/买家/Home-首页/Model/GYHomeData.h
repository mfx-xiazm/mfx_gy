//
//  GYHomeData.h
//  GY
//
//  Created by 夏增明 on 2019/10/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GYHomeBanner,GYHomeNotice,GYHomeTopCate,GYHomeCate,GYHomeCateGood;
@interface GYHomeData : NSObject
@property(nonatomic,assign) BOOL homeunReadMsg;
@property(nonatomic,strong) NSArray<GYHomeBanner *> *homeAdv;
@property(nonatomic,strong) NSArray<GYHomeNotice *> *homeNotice;
@property(nonatomic,strong) NSArray<GYHomeTopCate *> *homeTopCate;
@property(nonatomic,strong) NSArray<GYHomeCate *> *homeCate;
@end

@interface GYHomeBanner : NSObject
@property(nonatomic,copy) NSString *adv_id;
@property(nonatomic,copy) NSString *adv_name;
@property(nonatomic,copy) NSString *adv_pc_img;
@property(nonatomic,copy) NSString *adv_phone_img;
/** 1仅图片 2链接内容 3html富文本内容 4产品详情 */
@property(nonatomic,copy) NSString *adv_type;
@property(nonatomic,copy) NSString *adv_content;
@property(nonatomic,copy) NSString *ordid;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *root;

@end

@interface GYHomeNotice : NSObject
@property(nonatomic,copy) NSString *notice_id;
@property(nonatomic,copy) NSString *notice_title;
@property(nonatomic,copy) NSString *notice_content;
@property(nonatomic,copy) NSString *create_time;
@end

@interface GYHomeTopCate : NSObject
@property(nonatomic,copy) NSString *cate_name;
@property(nonatomic,copy) NSString *image_name;
@end

@interface GYHomeCate : NSObject
@property(nonatomic,copy) NSString *cate_id;
@property(nonatomic,copy) NSString *cate_name;
@property(nonatomic,copy) NSString *home_left_img;
@property(nonatomic,copy) NSString *home_pc_img;
@property(nonatomic,copy) NSString *home_phone_img;
@property(nonatomic,copy) NSString *ordid;
@property(nonatomic,copy) NSString *parent_cate_id;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,strong) NSArray<GYHomeCateGood *> *goods;

@end
@interface GYHomeCateGood : NSObject
@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *goods_id;
@property(nonatomic,copy) NSString *goods_name;
@property(nonatomic,copy) NSString *cover_img;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *market_price;
@property(nonatomic,copy) NSString *brand_img;
@end

NS_ASSUME_NONNULL_END
