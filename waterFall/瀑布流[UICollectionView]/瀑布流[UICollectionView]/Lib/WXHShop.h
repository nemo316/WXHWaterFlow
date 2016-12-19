//
//  WXHShop.h
//  瀑布流[UICollectionView]
//
//  Created by nemo on 2015/11/28.
//  Copyright © 2015年 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXHShop : NSObject
/** 图片宽*/
@property (nonatomic, assign) CGFloat w;
/** 图片高*/
@property (nonatomic, assign) CGFloat h;
/** 图片名称(网络加载时为图片的url)*/
@property (nonatomic, copy) NSString *img;
/** 价格*/
@property (nonatomic, copy) NSString *price;
@end
