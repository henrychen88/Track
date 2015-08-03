//
//  RecordViewController.m
//  Track
//
//  Created by Henry on 15/7/31.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordDetailViewController.h"
#import "FMDBHelper.h"
#import "Riding.h"

@interface RecordViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *records;
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"骑行记录";
    self.records = [[FMDBHelper instance] queryData];
    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.tableView];
}

- (void)leftButtonAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.contentView.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if ([self.records[indexPath.row] isKindOfClass:[Riding class]]) {
        Riding *riding = self.records[indexPath.row];
        cell.textLabel.text = [[riding.date componentsSeparatedByString:@" "] firstObject];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RecordDetailViewController *viewController = [[RecordDetailViewController alloc]init];
    viewController.riding = self.records[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
