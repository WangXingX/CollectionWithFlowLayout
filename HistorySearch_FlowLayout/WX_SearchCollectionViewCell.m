//
//  WX_SearchCollectionViewCell.m
//  BaseProject
//
//  Created by 王星星 on 2020/7/27.
//  Copyright © 2020 wangxingxing. All rights reserved.
//

#import "WX_SearchCollectionViewCell.h"
#define itemPadding 15                       // itemsize 的间距
@implementation WX_SearchCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 60, 40)];
        _typeBtn.backgroundColor = [UIColor whiteColor];
        [_typeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_typeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        _typeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _typeBtn.titleLabel.numberOfLines = 0;
        _typeBtn.layer.masksToBounds = YES;
        _typeBtn.layer.cornerRadius = 5.0;
        _typeBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        _typeBtn.layer.borderWidth = 1.0;
        _typeBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.typeBtn];
    }
    return self;
}

- (void)loadDataToBtn:(NSString *)str isType:(NSInteger)isType{
    
    [self.typeBtn setTitle:str forState:0];
    CGFloat maxWidth = [[UIScreen mainScreen] bounds].size.width - itemPadding * 2 - 20 -(isType?0:100);  
    
     CGSize size = [str boundingRectWithSize:CGSizeMake(maxWidth, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15.0]} context:nil].size;
    if (size.width <maxWidth) {
        self.typeBtn.frame = CGRectMake(0, 0, size.width+30, 40);
    }else{
        self.typeBtn.frame = CGRectMake(0, 0, size.width, 40);
    }
    
}

- (CGSize)sizeForCell {    
    return CGSizeMake(self.typeBtn.frame.size.width, 40);
}
@end
