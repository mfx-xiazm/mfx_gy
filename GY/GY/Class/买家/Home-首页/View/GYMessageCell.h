//
//  GYMessageCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYMessage;
@interface GYMessageCell : UITableViewCell
/** 消息 */
@property(nonatomic,strong) GYMessage *msg;
@end

NS_ASSUME_NONNULL_END
