//
//  MyCollectionReusableView.m
//  Day13-UICollectionView
//
//  Created by 潘颖超 on 15/8/26.
//  Copyright (c) 2015年 Meakelra. All rights reserved.
//

#import "MyCollectionReusableView.h"

@implementation MyCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self createUI];
    }
    return self;
}


- (void)createUI{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/7., self.bounds.size.height)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor blackColor];
    _label.font = [UIFont systemFontOfSize:18.0];
    //添加到父视图上
    [self addSubview:_label];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, self.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
    
}

@end
