//
//  GYGoodsCommentCell.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYGoodsCommentLayout,GYGoodsCommentCell;

@protocol GYGoodsCommentCellDelegate <NSObject>
@optional
/** 点击了全文/收回 */
- (void)didClickMoreLessInCommentCell:(GYGoodsCommentCell *)Cell;
@end

@interface GYGoodsCommentCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 数据源 */
@property (nonatomic, strong) GYGoodsCommentLayout *commentLayout;
/** 代理 */
@property (nonatomic, assign) id<GYGoodsCommentCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
