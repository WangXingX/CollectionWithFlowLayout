//
//  WX_SearchCollectionViewCell.h
//  BaseProject
//
//  Created by 王星星 on 2020/7/27.
//  Copyright © 2020 wangxingxing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WX_SearchCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIButton *typeBtn;
/*! 返回cell的size */
- (CGSize)sizeForCell;

//isType =0 表示是课程类型页
//isType =1 表示是历史搜索记录页
- (void)loadDataToBtn:(NSString *)str isType:(NSInteger)isType;
@end

NS_ASSUME_NONNULL_END
