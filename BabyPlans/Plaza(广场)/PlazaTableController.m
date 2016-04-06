//
//  PlazaTableController.m
//  BabyPlans
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlazaTableController.h"
#import "CloudLogin.h"
#import "PlazaTopView.h"

enum{
    TableViewLeft,
    TableViewRight
} TableView;


#define tableHeaderHeight (45*SCREEN_WIDTH_RATIO55)
#define TabbleViewCount 2  //tabbleView的个数

@interface PlazaTableController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PlazaTopDelegate>

@property (nonatomic,strong) PlazaTopView * topView;

@property (nonatomic,strong) UITableView * tableViewLeft;

@property (nonatomic,strong) UITableView * tableViewRight;

@property (nonatomic,strong) UIScrollView * mainScrollView;

@property (nonatomic,strong) NSArray * dataArrLeft;
@property (nonatomic,strong) NSArray * dataArrRight;


@end

@implementation PlazaTableController

- (NSArray *)dataArrRight{

    if (!_dataArrRight) {
        [CloudLogin getPlazaDataWithType:@"0" page:@"1" count:@"5" success:^(NSDictionary *responseObject) {
            
            NSLog(@"%@",responseObject);
        } failure:^(NSError *errorMessage) {
            NSLog(@"广场接口请求Error ==%@",errorMessage);
        }];

    }
    
    return _dataArrRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataArrRight];
    [self createTopView];
}

- (void)createTopView{

    //顶部按钮
    self.topView = [[PlazaTopView alloc] initWithFrame:CGRectMake(0, KNavBarHeight, KScreenWidth, tableHeaderHeight)];
    self.topView.delegate = self;
    [self.view addSubview:_topView];
    
    //底层视图
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    _mainScrollView.backgroundColor = ColorI(0xff0000);
    _mainScrollView.contentSize = CGSizeMake(KScreenWidth*TabbleViewCount, 0);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    
    //将tabbleView添加到scrollerView上
    for (int i = 0; i < TabbleViewCount; i ++) {
        
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, KScreenHeight-KNavBarHeight) style:UITableViewStyleGrouped];
        
        if (i==0) {
            tableView.tag = TableViewLeft;
            self.tableViewLeft = tableView;
        }else{
            tableView.tag = TableViewRight;
            self.tableViewRight = tableView;
        }
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        
        [self.mainScrollView addSubview:tableView];
        
        
    }
    
    //将topView移到顶层
    [self.view bringSubviewToFront:_topView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * ident = @"PlazaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
#pragma mark---------ScrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (self.mainScrollView == scrollView) {
        CGFloat currentX = scrollView.contentOffset.x;
        currentX = currentX+KScreenWidth/2;
        
        int index = currentX/KScreenWidth;
        
        [self.topView selectAtIndex:index];
        
    }
}

#pragma ---mark-----PlazaTopViewDelegate
- (void)scrollToIndex:(NSInteger)index{

    CGFloat currentX = _mainScrollView.contentOffset.x;
    currentX = currentX+KScreenWidth/2;
    
    int cuIndex = currentX/KScreenWidth;
    
    if (cuIndex != index) {
        
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint scrollTo = CGPointMake(index*KScreenWidth, _mainScrollView.contentOffset.y);
            
            _mainScrollView.contentOffset = scrollTo;
        }];
        
    }
}
@end
