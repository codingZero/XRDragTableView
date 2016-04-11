//
//  ViewController3.m
//  XRDragTableViewDemo
//
//  Created by 肖睿 on 16/4/9.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import "ViewController3.h"
#import "XRDragTableView.h"
@interface ViewController3 ()
@property (weak, nonatomic) IBOutlet XRDragTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController3

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"a1", @"a2", @"a3",nil];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"b1", @"b2", @"b3", @"b4", nil];
        NSMutableArray *arr3 = [NSMutableArray arrayWithObjects:@"c1", @"c2", @"c3", nil];
        NSMutableArray *arr4 = [NSMutableArray arrayWithObjects:@"d1", @"d2", nil];
        NSMutableArray *arr5 = [NSMutableArray arrayWithObjects:@"e1", @"e2", @"e3", @"e4", nil];
        _dataArray = [NSMutableArray arrayWithObjects:arr1, arr2, arr3, arr4, arr5,nil];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分组交换";
    self.tableView.isGroup = YES;
    self.tableView.isExchange = YES;
    self.tableView.dataArray = self.dataArray;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"复原" style:UIBarButtonItemStyleDone target:self.tableView action:@selector(resetCellLocation)];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

@end
