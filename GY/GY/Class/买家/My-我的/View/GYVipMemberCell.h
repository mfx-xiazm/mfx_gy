//
//  GYVipMemberCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYMember;
@interface GYVipMemberCell : UICollectionViewCell
/* 会员 */
@property(nonatomic,strong) GYMember *mamber;
@end

NS_ASSUME_NONNULL_END
