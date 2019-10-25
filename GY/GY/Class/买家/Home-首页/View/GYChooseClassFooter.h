//
//  GYChooseClassFooter.h
//  GY
//
//  Created by 夏增明 on 2019/10/15.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^buyNumCall)(NSInteger num);
@interface GYChooseClassFooter : UICollectionReusableView
/* 库存 */
@property(nonatomic,assign) NSInteger stock_num;
@property (weak, nonatomic) IBOutlet UILabel *buy_num;
/* buyNumCall */
@property(nonatomic,copy) buyNumCall buyNumCall;
@end

NS_ASSUME_NONNULL_END
