//
//  SZCalendarCell.m
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "TLCalendarCell.h"

@implementation TLCalendarCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor whiteColor];
        
        
    }
    return self;
}


- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.height - 40)/2, (self.frame.size.width - 40)/2, 40, 40)];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        _dateLabel.layer.masksToBounds = YES;
        _dateLabel.layer.cornerRadius = 20;
        [self.dateLabel setTextColor:[UIColor blackColor]];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

-(void)setWeekModel:(TLCalendarModel *)weekModel{
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"yyyy-MM-dd"];
    NSString * tempDateString = [formatDate stringFromDate:weekModel.day];
    self.dateLabel.text = [NSString stringWithFormat:@"%.ld",[[tempDateString componentsSeparatedByString:@"-"] lastObject].integerValue];
    if (weekModel.isToday) {
        self.dateLabel.backgroundColor = [UIColor blueColor];
    }
    if (self.isSelected) {
        self.dateLabel.backgroundColor = [UIColor lightGrayColor];
    }
}


@end
