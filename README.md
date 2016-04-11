# XRDragTableView
a tableView which can sequence by drag cell

一个可以通过长按来拖动cell进行排序与分组的tableView

感谢[moayes/UDo](https://github.com/moayes/UDo)的思路

实现原理[请看这里](http://www.jianshu.com/p/cffd35628442)
______


#使用步骤
###导入
将XRDragTableView文件夹中的所有文件添加到项目中

或通过cocoapods导入  pod 'XRDragTableView'

###使用
1.导入头文件 XRDragTableView.h

2.代码创建XRDragTableView对象，并设置属性

3.或者在xib\sb中添加tableView，设置class为XRDragTableView，拖线并设置属性

4.其他使用方式与UITableView一样


#常用属性及方法

1.dataArray：模型数组

2.isExchange：移动cell是插入还是交换

3.isGroup：是否有分组

4.scrollSpeed：拖动cell到tableView边缘时，tableView自动滚动的速度

5.resetCellLocation：重置所有cell到拖动之前的位置



#效果图
![](http://ww4.sinaimg.cn/large/b68232a1gw1f2somt91cog20a90ij4dy.gif)

    