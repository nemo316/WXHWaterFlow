//
//  ViewController.m
//  瀑布流[UICollectionView]
//
//  Created by nemo on 2015/11/28.
//  Copyright © 2015年 nemo. All rights reserved.
//

#import "ViewController.h"
#import "WXHWaterFlowLayout.h"
#import "WXHShop.h"
#import "WXHShopCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
static NSString *const ID = @"shop";
@interface ViewController ()<UICollectionViewDataSource,WXHWaterFlowLayoutDelegate>
/** 存放商品模型的数组*/
@property(nonatomic,strong) NSMutableArray *shops;
/** collectionView*/
@property(nonatomic,weak) UICollectionView *collectionView;
@end

@implementation ViewController
// 懒加载
- (NSMutableArray *)shops{
    if (_shops == nil) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建collectionView
    [self setupLayout];
    
    // 设置刷新
    [self setupRefresh];
    
}
#pragma mark - 创建collectionView
- (void)setupLayout{
    WXHWaterFlowLayout *layout = [[WXHWaterFlowLayout alloc] init];
    layout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = (id)self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WXHShopCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    self.collectionView = collectionView;
}
#pragma mark - 设置刷新
- (void)setupRefresh{
    // 头部下拉加载新数据
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.collectionView.header beginRefreshing];
    
    // 底部上拉加载更多数据
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // view加载完毕,先让底部隐藏
    self.collectionView.footer.hidden = YES;
}
#pragma mark - 加载新数据
- (void)loadNewData{
    // 模拟网路延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 利用MJExtention plist文件转模型
        NSArray *shops = [WXHShop objectArrayWithFilename:@"1.plist"];
        // 加载新数据时,先清空shops数组中所有数据
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:shops];
        
        [self.collectionView.header endRefreshing];
        // 勿忘重新刷新一下collectionView
        [self.collectionView reloadData];
    });
}
#pragma mark - 加载更多数据
- (void)loadMoreData{
    // 模拟网路延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 加载新数据时,先清空shops数组中所有数据
        NSArray *shops = [WXHShop objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        
        [self.collectionView.footer endRefreshing];
        // 勿忘重新刷新一下collectionView
        [self.collectionView reloadData];
    });
}
#pragma mark - <UICollectionViewDatasource>
#pragma mark * item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // 当模型中没有数据(网络加载没有返回数据)时,即数组为空的时候,隐藏底部加载更多
    self.collectionView.footer.hidden = (self.shops.count == 0);
    return self.shops.count;
}
#pragma mark * 设置对应的cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WXHShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.row];
    return cell;
}
#pragma mark - <WXHWaterflowLayoutDelegate>
#pragma mark * 设置每个item的高
- (CGFloat)waterflowLayout:(WXHWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    WXHShop *shop = self.shops[index];
    // 等比例缩放
    return itemWidth * shop.h / shop.w;
}
#pragma mark * 行距
- (CGFloat)rowMarginInWaterflowLayout:(WXHWaterFlowLayout *)waterflowLayout
{
    return 10;
}
#pragma mark * 列数
- (CGFloat)columnCountInWaterflowLayout:(WXHWaterFlowLayout *)waterflowLayout
{
    // 模拟数据过多
    if (self.shops.count <= 50) return 2;
    return 3;
}
#pragma mark * 边缘距离
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WXHWaterFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(10, 10, 30, 10);
}

@end
