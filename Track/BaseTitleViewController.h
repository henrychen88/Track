//
//  BaseTitleViewController.h
//  Track
//
//  Created by Henry on 15/7/31.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTitleViewController : UIViewController<UINavigationControllerDelegate>

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIButton *rightButton;

@property(nonatomic, strong) UIButton *leftButton;
/* 除去topView用来添加其他子视图的空间 */
@property(nonatomic, strong, readonly) UIView *contentView;

/**
 *  页面右上角按钮事件
 *
 *  @param button button description
 */
- (void)rightButtonAction:(UIButton *)button;

- (void)leftButtonAction:(UIButton *)button;

@end
