//
//  ViewController.m
//  XRDragTableViewDemo
//
//  Created by 肖睿 on 16/4/9.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import "ViewController.h"
#import "XRDragTableView.h"
@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet XRDragTableView *dragTableView;
@end

@implementation ViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    }
    return _dataArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"不分组插入";
    
    self.dragTableView.dataArray = self.dataArray;
    //当cell拖动到tableView边缘时，tableView自动滚动的速度
    self.dragTableView.scrollSpeed = 10;
    /*
     //错误写法一
     self.dragTableView.dataArray = [self.dataArray copy];
     //错误写法二
     self.dragTableView.dataArray = [self.dataArray mutableCopy];
     */
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"复原" style:UIBarButtonItemStyleDone target:self.dragTableView action:@selector(resetCellLocation)];
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
