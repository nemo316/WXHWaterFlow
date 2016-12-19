//
//  WXGShopCell.h
//  瀑布流[UICollectionView]
//
//  Created by nemo on 2015/11/28.
//  Copyright © 2015年 nemo. All rights reserved.
//

#import "WXHShopCell.h"
#import "WXHShop.h"
#import "UIImageView+WebCache.h"

@interface WXHShopCell()
/** 图片view*/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 价格label*/
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation WXHShopCell

- (void)setShop:(WXHShop *)shop
{
    _shop = shop;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.priceLabel.text = shop.price;
}
@end
