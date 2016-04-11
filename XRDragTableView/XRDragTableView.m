//
//  XRDragTableView.m
//  XRDragTableViewDemo
//
//  Created by 肖睿 on 16/4/9.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import "XRDragTableView.h"
typedef enum {
    AutoScrollUp,
    AutoScrollDown
} AutoScroll;


@interface XRDragTableView()
@property (nonatomic, strong) NSMutableArray *originalArray;
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) NSIndexPath *fromIndexPath;
@property (nonatomic, strong) NSIndexPath *toIndexPath;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) AutoScroll autoScroll;
@property (nonatomic, assign) NSInteger index;
@end

@implementation XRDragTableView


//无论tableView是用代码创建还是xib创建，都会调用该方法
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    //设置默认滚动速度为3
    if (_scrollSpeed == 0) _scrollSpeed = 3;
    //给tableView添加手势
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveRow:)]];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    _originalArray = [dataArray mutableCopy];
    if (_isGroup) {
        for (int i = 0; i < dataArray.count; i++) {
            _originalArray[i] = [dataArray[i] mutableCopy];
        }
    }
}


- (void)moveRow:(UILongPressGestureRecognizer *)sender {
    //获取点击的位置
    CGPoint point = [sender locationInView:self];
    if (sender.state == UIGestureRecognizerStateBegan) {
        //根据手势点击的位置，获取被点击cell所在的indexPath
        self.fromIndexPath = [self indexPathForRowAtPoint:point];
        
        if (!_fromIndexPath) return;
        //根据indexPath获取cell
        UITableViewCell *cell = [self cellForRowAtIndexPath:_fromIndexPath];
        
        //创建一个imageView，imageView的image由cell渲染得来
        self.cellImageView = [self createCellImageView:cell];
        
        //更改imageView的中心点为手指点击位置
        CGPoint center = cell.center;
        self.cellImageView.center = center;
        
        //隐藏要移动的cell
        cell.hidden = YES;
        
    } else if (sender.state == UIGestureRecognizerStateChanged){
        //根据手势的位置，获取手指移动到的cell的indexPath
        _toIndexPath = [self indexPathForRowAtPoint:point];
        
        //更改imageView的中心点为手指点击位置
        CGPoint center = self.cellImageView.center;
        center.y = point.y;
        self.cellImageView.center = center;

        //判断cell是否被拖拽到了tableView的边缘，如果是，则自动滚动tableView
        if ([self isScrollToEdge]) {
            [self startTimerToScrollTableView];
        } else {
            [_displayLink invalidate];
        }
        
        /*
         若当前手指所在indexPath不是要移动cell的indexPath，
         且是插入模式，则执行cell的插入操作
         每次移动手指都要执行该判断，实时插入
        */
        if (_toIndexPath && ![_toIndexPath isEqual:_fromIndexPath] && !self.isExchange)
            [self insertCell:_toIndexPath];
        
    } else {
        /*
         如果是交换模式，则执行交换操作
         交换操作等手势结束时执行，不用每次移动都执行
         */
        if (self.isExchange) [self exchangeCell:point];
        [_displayLink invalidate];
        //将隐藏的cell显示出来，并将imageView移除掉
        UITableViewCell *cell = [self cellForRowAtIndexPath:_fromIndexPath];
        cell.hidden = NO;
        [self.cellImageView removeFromSuperview];
    }
}

- (BOOL)isScrollToEdge {
    if ((CGRectGetMaxY(self.cellImageView.frame) > self.contentOffset.y + self.frame.size.height - self.contentInset.bottom) && (self.contentOffset.y < self.contentSize.height - self.frame.size.height + self.contentInset.bottom)) {
        self.autoScroll = AutoScrollDown;
        return YES;
    }
    
    if ((self.cellImageView.frame.origin.y < self.contentOffset.y + self.contentInset.top) && (self.contentOffset.y > -self.contentInset.top)) {
        self.autoScroll = AutoScrollUp;
        return YES;
    }
    return NO;
}

- (void)startTimerToScrollTableView {
    [_displayLink invalidate];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTableView)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)scrollTableView{
    if ((_autoScroll == AutoScrollUp && self.contentOffset.y <= -self.contentInset.top)
        || (_autoScroll == AutoScrollDown && self.contentOffset.y >= self.contentSize.height - self.frame.size.height + self.contentInset.bottom)) {
            [_displayLink invalidate];
            return;
    }
    
    CGFloat height = _autoScroll == AutoScrollUp? -_scrollSpeed : _scrollSpeed;
    [self setContentOffset:CGPointMake(0, self.contentOffset.y + height)];
    _cellImageView.center = CGPointMake(_cellImageView.center.x, _cellImageView.center.y + height);
    
    _toIndexPath = [self indexPathForRowAtPoint:_cellImageView.center];
    if (_toIndexPath && ![_toIndexPath isEqual:_fromIndexPath] && !self.isExchange)
        [self insertCell:_toIndexPath];
}


- (void)insertCell:(NSIndexPath *)toIndexPath {
    if (self.isGroup) {
        //先将cell的数据模型从之前的数组中移除，然后再插入新的数组
        NSMutableArray *fromSection = self.dataArray[_fromIndexPath.section];
        NSMutableArray *toSection = self.dataArray[toIndexPath.section];
        id obj = fromSection[_fromIndexPath.row];
        [fromSection removeObject:obj];
        [toSection insertObject:obj atIndex:toIndexPath.row];
        
        //如果某个组的所有cell都被移动到其他组，则删除这个组
        if (!fromSection.count) {
            [self.dataArray removeObject:fromSection];
        }
    } else {
        //交换两个cell的数据模型
        [self.dataArray exchangeObjectAtIndex:_fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    }
    [self reloadData];
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:toIndexPath];
    cell.hidden = YES;
    _fromIndexPath = toIndexPath;
}


- (void)exchangeCell:(CGPoint)point {
    NSIndexPath *toIndexPath = [self indexPathForRowAtPoint:point];
    if (!toIndexPath) return;
    //交换要移动cell与被替换cell的数据模型
    if (self.isGroup) {
        //分组情况下，交换模型的过程比较复杂
        NSMutableArray *fromSection = self.dataArray[_fromIndexPath.section];
        NSMutableArray *toSection = self.dataArray[toIndexPath.section];
        id obj = fromSection[_fromIndexPath.row];
        [fromSection replaceObjectAtIndex:_fromIndexPath.row withObject:toSection[toIndexPath.row]];
        [toSection replaceObjectAtIndex:toIndexPath.row withObject:obj];
    } else {
        [self.dataArray exchangeObjectAtIndex:_fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    }
    [self reloadData];
}


- (void)resetCellLocation {
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:_originalArray];
    if (_isGroup) {
        for (int i = 0; i < _dataArray.count; i++) {
            _originalArray[i] = [_dataArray[i] mutableCopy];
        }
    }
    [self reloadData];
}

- (UIImageView *)createCellImageView:(UITableViewCell *)cell {
    //打开图形上下文，并将cell的根层渲染到上下文中，生成图片
    UIGraphicsBeginImageContext(cell.bounds.size);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *cellImageView = [[UIImageView alloc] initWithImage:image];
    cellImageView.alpha = 0.8;
    [self addSubview:cellImageView];
    return cellImageView;
}

@end
