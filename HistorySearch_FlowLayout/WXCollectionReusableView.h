//
//  WXCollectionReusableView.h
//  BaseProject
//
//  Created by 王星星 on 2020/7/28.
//  Copyright © 2020 wangxingxing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) UIButton *openBtn;
@property (assign, nonatomic) NSInteger isOpen;

@property (strong, nonatomic) UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
