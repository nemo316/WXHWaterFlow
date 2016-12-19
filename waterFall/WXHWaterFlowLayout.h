//
//  WXHWaterFlowLayout.h
//  瀑布流[UICollectionView]
//
//  Created by nemo on 2015/11/28.
//  Copyright © 2015年 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WXHWaterFlowLayout;
@protocol WXHWaterFlowLayoutDelegate <NSObject>

@required
/**
 *  设置每个item的高
 *
 *  @param waterflowLayout 瀑布流布局
 *  @param index           索引
 *  @param itemWidth       宽度
 *
 *  @return 宽度
 */
- (CGFloat)waterflowLayout:(WXHWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/**
 *  设置列数
 *
 *  @param waterflowLayout 瀑布流布局
 *
 *  @return 列数
 */
- (CGFloat)columnCountInWaterflowLayout:(WXHWaterFlowLayout *)waterflowLayout;
/**
 *  设置列距
 *
 *  @param waterflowLayout 瀑布流布局
 *
 *  @return 列距
 */
- (CGFloat)columnMarginInWaterflowLayout:(WXHWaterFlowLayout *)waterflowLayout;
/**
 *  设置行距
 *
 *  @param waterflowLayout 瀑布流布局
 *
 *  @return 行距
 */
- (CGFloat)rowMarginInWaterflowLayout:(WXHWaterFlowLayout *)waterflowLayout;
/**
 *  设置边缘距离
 *
 *  @param waterflowLayout 瀑布流布局
 *
 *  @return 边缘距离
 */
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WXHWaterFlowLayout *)waterflowLayout;
@end
@interface WXHWaterFlowLayout : UICollectionViewLayout
/** 代理*/
@property(nonatomic,weak) id<WXHWaterFlowLayoutDelegate> delegate;
@end
