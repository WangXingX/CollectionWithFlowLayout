//
//  WX_TypeFlowLayout.m
//  BaseProject
//
//  Created by 王星星 on 2020/7/27.
//  Copyright © 2020 wangxingxing. All rights reserved.
//

#import "WX_TypeFlowLayout.h"
#define itemPadding 15                       // itemsize 的间距
@implementation WX_TypeFlowLayout

- (instancetype)init{
if (self = [super init]) {
    //普通处理的item的间距
    self.minimumLineSpacing = itemPadding;
    self.minimumInteritemSpacing = itemPadding;
    //要特殊处理的item的间距
    self.maximumInteritemSpacing = itemPadding;

}
    return self;
}

#pragma mark ********  重写 流水布局方法 ********
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
//使用系统帮我们计算好的结果。
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes * att in attributes) {
        //只对cell进行操作，header跟footer不操作
        if (!att.representedElementKind) {
            [attributesArray addObject:att];
        }
    }
    //特殊处理第一个元素(防止第一个元素的x不居左显示)
    if (attributesArray.count > 0) {
        //只有一个item的时候居左显示
        UICollectionViewLayoutAttributes *curAttr = attributesArray[0];
        CGRect frame = curAttr.frame;
        frame.origin.x = 0;
        curAttr.frame = frame;
    }
        //第0个cell没有上一个cell，所以从1开始
    for(int i = 1; i < [attributesArray count]; ++i) {
    //这里 UICollectionViewLayoutAttributes 的排列总是按照 indexPath的顺序来的。
        UICollectionViewLayoutAttributes *curAttr = attributesArray[i];
        UICollectionViewLayoutAttributes *preAttr = attributesArray[i-1];
        NSInteger origin = CGRectGetMaxX(preAttr.frame);
        //根据 maximumInteritemSpacing 计算出的新的 x 位置
        CGFloat targetX = origin + _maximumInteritemSpacing;
        // 只有系统计算的间距大于 maximumInteritemSpacing 时才进行调整
        if (CGRectGetMinX(curAttr.frame) > targetX) {
        // 换行时不用调整
            if (targetX + CGRectGetWidth(curAttr.frame) < self.collectionViewContentSize.width) {
                CGRect frame = curAttr.frame;
                frame.origin.x = targetX;
                curAttr.frame = frame;
            }
        }else{
            //加这个的目的是为了让单独行居左，不然默认会居中显示
            CGRect frame = curAttr.frame;
            frame.origin.x = 0;
            curAttr.frame = frame;
        }
    }
    return attributes;
}
@end
