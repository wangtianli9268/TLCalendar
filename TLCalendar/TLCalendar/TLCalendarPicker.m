//
//  SZCalendarPicker.m
//  TLCalendar
//
//  Created by 王天丽 on 16/11/1.
//  Copyright © 2016年 王天丽. All rights reserved.
//

#import "TLCalendarPicker.h"
#import "TLCalendarCell.h"
#import "MyCollectionReusableView.h"
#import "TLCalendarModel.h"


@interface TLCalendarPicker()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UIView *mask;
@property (nonatomic , strong) NSArray *weekDayArray;
@property (nonatomic , strong) NSMutableArray *dataSource;
@property (nonatomic , strong) NSArray *weekArray;
@property (nonatomic , strong) UILabel *leftLabel;
@property (nonatomic , assign) BOOL isFold;



@end
@implementation TLCalendarPicker
NSInteger selectWeekDay = 0;
CGFloat lastContentOffset = 0;



- (void)drawRect:(CGRect)rect {
    [self createUI];
}


-(void)createUI{
    _lastDate = self.today;
    _date = [self nextMonth:self.date];
    _dataSource = [[NSMutableArray alloc]initWithObjects:self.today,self.date, nil];
    _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    _weekArray = [NSArray array];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
    view.backgroundColor = [UIColor grayColor];
    [self addSubview:view];
    
    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 200)/2.,20, 200, 20)];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.leftLabel.text = [NSString stringWithFormat:@"%li年%li月",[self year:_today],[self month:_today]];
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:self.leftLabel];
    
    NSArray *imageArr = @[@"btn_shijian_nor",@"形状-197"];
    for (int i = 0; i < 2; i++) {
       UIButton *foldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            foldBtn.frame = CGRectMake(10, 20, 20, 20);
        }else{
            foldBtn.frame = CGRectMake(self.frame.size.width - 30, 19, 20, 22);
            foldBtn.hidden = YES;
        }
        foldBtn.tag = i + 5000;
        [foldBtn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [foldBtn addTarget:self action:@selector(foldClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:foldBtn];
    }
    
    
    
    
    for (int i = 0; i < 7; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/7.*i, 40, self.frame.size.width/7., 20)];
        label.text = _weekDayArray[i];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(50, 0, 0, 0);
    layout.itemSize = CGSizeMake(self.frame.size.width/7., self.frame.size.width/7.);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,   self.frame.size.width, self.frame.size.height - 60) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [_collectionView registerClass:[TLCalendarCell class] forCellWithReuseIdentifier:@"iden"];
    [self.mask addSubview:_collectionView];
    
    [_collectionView registerClass:[MyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
    
    
    //添加上下滑动的手势
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.mask addGestureRecognizer:upSwipe];
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.mask addGestureRecognizer:downSwipe];
    
}



+ (instancetype)showOnView:(UIView *)view
{
    //加载nib文件时firstObject 和 lastObject 的区别
    //SZCalendarPicker *calendarPicker = [[[NSBundle mainBundle] loadNibNamed:@"SZCalendarPicker" owner:self options:nil] lastObject];
    TLCalendarPicker *calendarPicker = [[TLCalendarPicker alloc]init];
    calendarPicker.backgroundColor = [UIColor whiteColor];
    calendarPicker.mask = [[UIView alloc] initWithFrame:calendarPicker.bounds];
    calendarPicker.mask.backgroundColor = [UIColor orangeColor];
    [view addSubview:calendarPicker];
    [calendarPicker addSubview:calendarPicker.mask];
    return calendarPicker;
    
}

#pragma mark collectionview delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.isFold) {
        return 1;
    }
    return _dataSource.count;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isFold) {
        return 7;
    }else{
        NSInteger allDays = [self totaldaysInMonth:_dataSource[section]];
        NSInteger firstWeekDay = [self firstWeekdayInThisMonth:_dataSource[section]];
        if (allDays == 31) {
            if (firstWeekDay < 5) {
                return 35;
            }else{
                return 42;
            }
        }else if (allDays == 28){
            if (firstWeekDay == 1) {
                return 28;
            }else{
                return 35;
            }
        }
        return 35;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TLCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iden" forIndexPath:indexPath];
    cell.dateLabel.backgroundColor = [UIColor clearColor];
    if (self.isFold) {
        
        if (indexPath.row == selectWeekDay - 1) {
            cell.dateLabel.backgroundColor = [UIColor lightGrayColor];
        }
        TLCalendarModel *model = _weekArray[indexPath.row];
        cell.weekModel = model;
        
        
    }else{
        NSInteger daysInThisMonth = [self totaldaysInMonth:_dataSource[indexPath.section]];
        //这个月第一天对应的星期几 0-周天 1-周一
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_dataSource[indexPath.section]];
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        if (i < firstWeekday || i > firstWeekday + daysInThisMonth - 1) {
            //这个月第一天之前和最后一天之后不显示
            [cell.dateLabel setText:@""];
        }else{
            day = i - firstWeekday + 1;
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            cell.dateLabel.backgroundColor = [UIColor clearColor];            //this month
            if ([_today isEqualToDate:_dataSource[indexPath.section]]) {
                if (day == [self day:_dataSource[indexPath.section]]) {
                    cell.dateLabel.backgroundColor = [UIColor blueColor];
                }else{
                    cell.dateLabel.backgroundColor = [UIColor clearColor];
                }
            }else{
                cell.dateLabel.backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    
    return cell;
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isFold){
        //折叠起来的时候都可以点击
        return YES;
    
    }else{
        //（打开）当前月显示的日期才可以点击，否则不可点击
        NSInteger daysInThisMonth = [self totaldaysInMonth:_dataSource[indexPath.section]];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_dataSource[indexPath.section]];
        NSInteger i = indexPath.row;
        if (i < firstWeekday || i > firstWeekday + daysInThisMonth - 1) {
            return NO;
        }else{
            return YES;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isFold) {
        //点击按钮，改变背景色，变成选中状态
        selectWeekDay = indexPath.item + 1;
        TLCalendarModel *selectModel = _weekArray[indexPath.item];
        selectModel.isSelected = YES;
        
        [collectionView reloadData];
        
        
        //取得当前显示数组周天的时间
        TLCalendarModel * model =  self.weekArray[0];
        NSDate * sunDate = model.day;
        //得到当前点击的时间
        NSDate *selectDate = [sunDate dateByAddingTimeInterval:(selectWeekDay - 1)*24*60*60];
        //将所点击时间显示在最上面
        [self getFoldStrinFromDate:selectDate];
        
        
    }else{
        NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_dataSource[indexPath.section]];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_dataSource[indexPath.section]];
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        day = i - firstWeekday + 1;
        //将所点击的日期传回去
        if (self.calendarBlock) {
            self.calendarBlock(day, [comp month], [comp year]);
        }
        //将点击的时间字符串转为时间戳
        NSString* dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[comp year],(long)[comp month],(long)day];
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [formater dateFromString:dateStr];
        NSLog(@"+++++++%@",date);
        
        
        self.isFold = YES;
        self.weekArray = [self getWeekOfFirstDayWithDate:date];
        [self layoutSubviews];
        [_collectionView reloadData];
        
        NSInteger dateWeekNum = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
        selectWeekDay = dateWeekNum;
        
        [self getFoldStrinFromDate:date];
        
        UIButton *button = [self viewWithTag:5001];
        button.hidden = NO;
        
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(self.isFold){
        return CGSizeZero;
    }
    return CGSizeMake(self.frame.size.width, 50);
}


//设置每个section距离上左下右各个边的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}


#pragma mark calendar

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    //当前月份-1
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    //当前月份+1
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
    
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
    
}

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

- (void)setDate:(NSDate *)date
{
    //使用self.会出现内存泄漏，使用_没有问题，self. = 调用了set方法，造成循环引用， = self. 调用get方法
    _date = date;
    [_leftLabel setText:[NSString stringWithFormat:@"%li年%li月",[self year:date],[self month:date]]];
    
    [_collectionView reloadData];
}


-(void)setLastDate:(NSDate *)lastDate{
    _lastDate = lastDate;
    [_leftLabel setText:[NSString stringWithFormat:@"%li年%li月",[self year:lastDate],[self month:lastDate]]];
}


#pragma mark scroll
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //一边便利一边修改会奔溃'*** Collection <__NSArrayM: 0x600000240e10> was mutated while being enumerated.'解决办法：使用一个临时数组进行遍历，目标数组进行添加操作
    
    if (lastContentOffset < scrollView.contentOffset.y) {
        //NSLog(@"向上滚动");
        self.date = [self nextMonth:self.date];
        [_dataSource addObject:self.date];
        
    }else{
        // NSLog(@"向下滚动");
        
        self.lastDate = [self lastMonth:self.lastDate];
        [_dataSource insertObject:self.lastDate atIndex:0];
        
    }
    [self.collectionView reloadData];
}



//标题头或标题尾的设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //标题头或标题尾的设置 只能用自定义的方式，只能使用注册类的格式
    
    MyCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
    //当为标题头时
    if (kind == UICollectionElementKindSectionHeader) {
        view.label.text = [NSString stringWithFormat:@"%ld月",[self month:_dataSource[indexPath.section]]];
    }
    
    return view;
}


#pragma mark weekCalendar
// 获取传入日期当前周的数组
-(NSArray *)getWeekOfFirstDayWithDate:(NSDate *)date{
    
    NSInteger dateWeekNum = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
    NSTimeInterval nowTime = [date timeIntervalSince1970]; // date的时间戳
    NSDate *needTimeDate = [NSDate dateWithTimeIntervalSince1970:nowTime - (dateWeekNum - 1)* 24*60*60]; // 根据传入的时间 该周 计算周日的时间
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:7];
    for (NSInteger i = 0; i < 7; i++) {
        TLCalendarModel * model = [[TLCalendarModel alloc]init];
        NSDate * tempDate = [needTimeDate dateByAddingTimeInterval:i * 24 * 60 * 60];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlag = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
        NSDateComponents *comp1 = [calendar components:unitFlag fromDate:tempDate];
        NSDateComponents *comp2 = [calendar components:unitFlag fromDate:self.today];
        if (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year])) {
            model.isToday = YES;
        }
        model.day = tempDate;
        [tempArray addObject:model];
        NSLog(@"~~~~~~~~~~~~%d",model.isSelected);
    }
    return tempArray;
    
}

-(void)leftSwipe:(UIGestureRecognizer *)gesture{
    if (self.isFold) {
        
        TLCalendarModel * model =  self.weekArray[6];
        NSDate * nextDate = model.day;
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        [self.mask.layer addAnimation:transition forKey:@"animation"];
        
        self.weekArray = [self getWeekOfFirstDayWithDate:[nextDate dateByAddingTimeInterval:24 *60*60]];
        [self.collectionView reloadData];
        
        NSDate *date = [nextDate dateByAddingTimeInterval:24*selectWeekDay*60*60];
        [self getFoldStrinFromDate:date];
        
    }
}


-(void)rightSwipe:(UIGestureRecognizer *)gesture{
    if (self.isFold) {
        TLCalendarModel * model =  self.weekArray[0];
        NSDate * lastDate = model.day;
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromLeft;
        [self.mask.layer addAnimation:transition forKey:@"animation"];
        self.weekArray = [self getWeekOfFirstDayWithDate:[lastDate dateByAddingTimeInterval:-24 *60*60]];
        [self.collectionView reloadData];
        
        NSDate *date = [lastDate dateByAddingTimeInterval:-24*selectWeekDay*60*60];
        [self getFoldStrinFromDate:date];
        
    }
}

-(void)foldClick:(UIButton *)button{
    if (button.tag == 5000) {
        if (self.isFold) {
            self.isFold = NO;
        }else{
            self.isFold = YES;
            self.weekArray = [self getWeekOfFirstDayWithDate:self.today];
        }
        [self layoutSubviews];
    }else{
        self.weekArray = [self getWeekOfFirstDayWithDate:self.today];
    }
    [self.collectionView reloadData];
}


-(void)layoutSubviews{
    if (self.isFold) {
        self.mask.frame = CGRectMake(0, 60, self.frame.size.width, self.frame.size.width/7.);
    }else{
        self.mask.frame = CGRectMake(0, 60, self.frame.size.width, self.frame.size.height - 60);
    }
}


//时间转字符串
-(void)getFoldStrinFromDate:(NSDate *)date{
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDateString=[dateFormatter stringFromDate:date];
    _leftLabel.text = currentDateString;
}

//字符串转时间
-(NSDate *)getDateFromString:(NSString *)string{
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}



@end
