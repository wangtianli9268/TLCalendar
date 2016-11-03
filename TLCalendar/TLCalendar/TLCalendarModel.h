//
//  TLCalendarModel.h
//  TLCalendar
//
//  Created by 王天丽 on 16/11/2.
//  Copyright © 2016年 王天丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLCalendarModel : NSObject

@property(nonatomic,copy) NSDate *day;
@property(nonatomic,copy) NSString *state;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,assign) BOOL isToday;



@end
