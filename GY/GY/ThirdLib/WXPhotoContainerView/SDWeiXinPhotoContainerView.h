//
//  SDWeiXinPhotoContainerView.h
//  SDAutoLayout  Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^imageClickedCallBack)(NSInteger);
@interface SDWeiXinPhotoContainerView : UIView

@property (nonatomic, strong) NSArray *picPathStringsArray;
/* 目标控制器 */
@property(nonatomic,weak) UIViewController *targetVc;

@property (nonatomic, assign) int customImgWidth;

+ (CGSize)getContainerSizeWithPicPathStringsArray:(NSArray *)picPathStringsArray;

@end
