//
//  ViewController1.m
//  XRDragTableViewDemo
//
//  Created by 肖睿 on 16/4/9.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import "ViewController1.h"
#import "XRDragTableView.h"
@interface ViewController1 ()<UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) XRDragTableView *tableView;
@end

@implementation ViewController1


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"不分组交换";
    
    self.tableView = [[XRDragTableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:239.0 / 255 green:239.0 / 255 blue:244.0 / 255 alpha:1];
    [self.view addSubview:_tableView];
    
    self.tableView.isExchange = YES;
    self.tableView.dataArray = self.dataArray;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"复原" style:UIBarButtonItemStyleDone target:self.tableView action:@selector(resetCellLocation)];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

@end
