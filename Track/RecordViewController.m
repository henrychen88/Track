//
//  RecordViewController.m
//  Track
//
//  Created by Henry on 15/7/31.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "RecordViewController.h"

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
    
    self.records = [[FMDBHelper instance] queryData];
    
    [self.contentView addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
