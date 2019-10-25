//
//  GYMyNeedsCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYMyTasks;
@interface GYMyNeedsCell : UITableViewCell
/* 需求 */
@property(nonatomic,strong) GYMyTasks *task;
@end

NS_ASSUME_NONNULL_END
