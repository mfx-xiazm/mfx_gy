//
//  GYTopNoticeCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/14.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYNoticeViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class GYHomeNotice;
@interface GYTopNoticeCell : GYNoticeViewCell
/* 公告 */
@property(nonatomic,strong) GYHomeNotice *notice;
@end

NS_ASSUME_NONNULL_END
