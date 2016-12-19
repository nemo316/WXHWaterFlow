//
//  WXHWaterFlowLayout.m
//  瀑布流[UICollectionView]
//
//  Created by nemo on 2015/11/28.
//  Copyright © 2015年 nemo. All rights reserved.
//

#import "WXHWaterFlowLayout.h"

/** 列数*/
static const NSInteger defaultColumnCount = 3;
/** 列间距*/
static const CGFloat defaultColumnMargin = 10;
/** 行间距*/
static const CGFloat defaultRowMargin = 10;
/** 边缘间距*/
static const UIEdgeInsets defaultEdgeInsets = {10, 10, 10, 10}; 

@interface WXHWaterFlowLayout()
/** 存放布局属性的数组*/
@property(nonatomic,strong) NSMutableArray *attrsArray;
/** 存放所有列的当前高度*/
@property(nonatomic,strong) NSMutableArray *columnHeights;

// 常见数据
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
@end

@implementation WXHWaterFlowLayout
// 懒加载
- (NSMutableArray *)attrsArray{
    if (_attrsArray == nil) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}
- (NSMutableArray *)columnHeights{
    if (_columnHeights == nil) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

#pragma mark - 常见数据处理
#pragma mark * 行距
- (CGFloat)rowMargin
{
    // 如果外界没有调用该代理方法,则使用默认值
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return defaultRowMargin;
    }
}
#pragma mark * 列距
- (CGFloat)columnMargin
{
    // 如果外界没有调用该代理方法,则使用默认值
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return defaultColumnMargin;
    }
}
#pragma mark * 列数
- (NSInteger)columnCount
{
    // 如果外界没有调用该代理方法,则使用默认值
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return defaultColumnCount;
    }
}
#pragma mark * 边距
- (UIEdgeInsets)edgeInsets
{
    // 如果外界没有调用该代理方法,则使用默认值
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return defaultEdgeInsets;
    }
}

#pragma mark - 初始化
- (void)prepareLayout{
    [super prepareLayout];
    
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    // 首行
    for (NSInteger i = 0; i < self.columnCount; i ++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i ++) {
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 创建布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArray addObject:attrs];
        
    }
}
#pragma mark - 决定cell的排布
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attrsArray;
}
#pragma mark - 返回indexPath位置cell对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // collectionView的宽度
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    // 找出高度最短的那一列
//    NSInteger __block destColumn = 0;
//    CGFloat __block minColumnHeight = 0; // block中要修改外面的变量,必须加__block
//    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber * _Nonnull columnHeightNumber, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGFloat columnHeight = columnHeightNumber.doubleValue;
//        if (columnHeight < minColumnHeight) {
//            minColumnHeight = columnHeight;
//            destColumn = idx;
//        }
//    }];
    
    // 目的列
    NSInteger destColumn = 0;
    // 假定第一列最矮
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    // 则可以从1开始遍历(性能)
    for (NSInteger i = 1; i < self.columnCount; i ++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (columnHeight < minColumnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    // 设置布局属性的frame
    CGFloat w = (collectionViewWidth - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    CGFloat x = self.edgeInsets.left + destColumn * (self.columnMargin + w);
    CGFloat y = minColumnHeight;
    // 判断是否是第一排,如果是第一排则直接用top作为y
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    return attrs;
}
#pragma mark - 内容尺寸
- (CGSize)collectionViewContentSize{
    // 计算最高那一列的高度
    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i ++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (columnHeight > maxColumnHeight) {
            maxColumnHeight = columnHeight;
        }
    }
    return CGSizeMake(0, maxColumnHeight + self.rowMargin);
}

@end
