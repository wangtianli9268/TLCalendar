//
//  ViewController.m
//  TLCalendar
//
//  Created by 王天丽 on 16/11/1.
//  Copyright © 2016年 王天丽. All rights reserved.
//

#import "ViewController.h"
#import "TLCalendarPicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(200, 300, 40, 20)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)Click{
    TLCalendarPicker *calendarPicker = [TLCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        
        NSLog(@"%i-%i-%i", year,month,day);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
