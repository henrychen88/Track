//
//  BaseTitleViewController.m
//  Track
//
//  Created by Henry on 15/7/31.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "BaseTitleViewController.h"

@interface BaseTitleViewController ()
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UILabel *titleLabel;
/* 除去topView用来添加其他子视图的空间 */
@property(nonatomic, strong, readwrite) UIView *contentView;
@end

@implementation BaseTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupContent];
}

- (void)setupContent{
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.rightButton];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.contentView];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

#pragma mark - 视图控件

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];
        _topView.backgroundColor = [UIColor grayColor];
    }
    return  _topView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, CGRectGetWidth(self.view.bounds) - 160, CGRectGetHeight(self.topView.frame) - 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 60, 20, 50, CGRectGetHeight(self.titleLabel.frame))];
        [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (void)rightButtonAction:(UIButton *)button
{
    
}

- (UIView *)contentView
{
    if (!_contentView ) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64)];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}
@end
