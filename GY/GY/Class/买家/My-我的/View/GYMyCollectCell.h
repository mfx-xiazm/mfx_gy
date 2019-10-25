//
//  GYMyCollectCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYMyCollect;
typedef void(^selectCollectCall)(void);
@interface GYMyCollectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
/* 收藏 */
@property(nonatomic,strong) GYMyCollect *collect;
/* 选择 */
@property(nonatomic,copy) selectCollectCall selectCollectCall;
@end

NS_ASSUME_NONNULL_END
