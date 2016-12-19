# WXHWaterFlow
## pragma mark * 设置每个item的高
```objc
- (CGFloat)waterflowLayout:(WXHWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    WXHShop *shop = self.shops[index];
    // 等比例缩放
    return itemWidth * shop.h / shop.w;
}
```

##pragma mark * 行距
```objc
- (CGFloat)rowMarginInWaterflowLayout:(WXHWaterFlowLayout *)waterflowLayout
{
    return 10;
}
```
##pragma mark * 列数
```objc
- (CGFloat)columnCountInWaterflowLayout:(WXHWaterFlowLayout *)waterflowLayout
{
    // 模拟数据过多
    if (self.shops.count <= 50) return 2;
    return 3;
}
```
##pragma mark * 边缘距离
```objc
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WXHWaterFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(10, 10, 30, 10);
}
```


