//
//  GYGoodsCate.h
//  GY
//
//  Created by 夏增明 on 2019/10/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GYGoodsSubCate;
@interface GYGoodsCate : NSObject
@property(nonatomic,copy) NSString *cate_id;
@property(nonatomic,copy) NSString *cate_name;
@property(nonatomic,copy) NSString *ordid;
@property(nonatomic,strong) NSArray<GYGoodsSubCate *> *sub;

@end

@interface GYGoodsSubCate : NSObject
@property(nonatomic,copy) NSString *cate_id;
@property(nonatomic,copy) NSString *cate_name;
@property(nonatomic,copy) NSString *ordid;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end
NS_ASSUME_NONNULL_END
