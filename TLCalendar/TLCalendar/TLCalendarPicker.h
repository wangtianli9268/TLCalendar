//
//  SZCalendarPicker.h
//  TLCalendar
//
//  Created by 王天丽 on 16/11/1.
//  Copyright © 2016年 王天丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLCalendarPicker : UIView
@property (nonatomic , strong) NSDate *lastDate;
@property (nonatomic , strong) NSDate *date;
@property (nonatomic , strong) NSDate *today;

@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);

+ (instancetype)showOnView:(UIView *)view;

@end
