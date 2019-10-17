//
//  GYTabBar.h
//  GY
//
//  Created by 夏增明 on 2019/10/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYTabBar;
@protocol GYTabBarDelegate <UITabBarDelegate>
@optional

-(void)tabBarDidClickPlusButton:(GYTabBar *)tabBar;
@end

@interface GYTabBar : UITabBar

@property(nonatomic,weak)id <GYTabBarDelegate> rcDelegate;
@end

NS_ASSUME_NONNULL_END
