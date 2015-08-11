//
//  BaseTitleViewController.m
//  Track
//
//  Created by Henry on 15/7/31.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "BaseTitleViewController.h"

@interface BaseTitleViewController ()<UIGestureRecognizerDelegate>
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
    NSLog(@"interactivePopGestureRecognizer %@", self.navigationController.interactivePopGestureRecognizer);
    NSLog(@"target : %@", self.navigationController.interactivePopGestureRecognizer.delegate);
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
#pragma clang diagnostic pop

    
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.navigationController.viewControllers.count > 1;
}

- (void)setupContent{
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.rightButton];
    [self.topView addSubview:self.leftButton];
    
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

- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, CGRectGetHeight(self.titleLabel.frame))];
        [_leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (void)rightButtonAction:(UIButton *)button
{
    
}

- (void)leftButtonAction:(UIButton *)button
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
