//
//  WXCollectionReusableView.m
//  BaseProject
//
//  Created by 王星星 on 2020/7/28.
//  Copyright © 2020 wangxingxing. All rights reserved.
//

#import "WXCollectionReusableView.h"

@implementation WXCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.openBtn = [[UIButton alloc]initWithFrame:CGRectMake( frame.size.width - 80, 0 , 80 , frame.size.height)];
//        [self.openBtn setTitle:@"^" forState:0];
        [self.openBtn setTitleColor:[UIColor blackColor] forState:0];
        [self addSubview:self.openBtn];
        
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width - 80, frame.size.height)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.titleLabel.textColor = [UIColor darkTextColor];
        [self addSubview:self.titleLabel];
        
       
        
//        self.openBtn.hidden = !self.isOpen;
    }
    return self;
}
@end
