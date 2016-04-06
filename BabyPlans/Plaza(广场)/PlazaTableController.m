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
#import "PlazaDataModel.h"
#import "PlazaMainCell.h"
#import "PlazaDataFrame.h"

enum{
    TableViewLeft,
    TableViewRight
} TableView;

enum{
    DataTypeOrginal, //原创绘本
    DataTypeClassical //经典绘本
} DataType;


#define tableHeaderHeight (45*SCREEN_WIDTH_RATIO55)
#define TabbleViewCount 2  //tabbleView的个数



@interface PlazaTableController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PlazaTopDelegate>

@property (nonatomic,strong) PlazaTopView * topView;

@property (nonatomic,strong) UITableView * tableViewLeft;

@property (nonatomic,strong) UITableView * tableViewRight;

@property (nonatomic,strong) UIScrollView * mainScrollView;

@property (nonatomic,strong) NSArray * dataArrLeft;
@property (nonatomic,strong) NSArray * dataArrRight;
/**
 *  经典绘本页码
 */
@property (nonatomic,assign) int pageClassical;
/**
 *  原创绘本页码
 */
@property (nonatomic,assign) int pageOrginal;


@end

@implementation PlazaTableController

- (NSArray *)dataArrLeft{
    
    if (!_dataArrLeft) {
        
        NSMutableArray * myDataArr = [NSMutableArray array];
        MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.dimBackground=YES;
        
        [self.view bringSubviewToFront:HUD];
        
        [CloudLogin getPlazaDataWithType:[NSString stringWithFormat:@"%d",DataTypeOrginal] page:@"1" count:@"5" success:^(NSDictionary *responseObject) {
            
            NSLog(@"原创绘本：==%@",responseObject);
            HUD.hidden = YES;
            NSArray * dataArr = responseObject[@"galleries"];
            
            for (NSDictionary * dic in dataArr) {
                
                PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                
                PlazaDataFrame * modelFrame = [[PlazaDataFrame alloc] init];
                modelFrame.model = model;
                
                [myDataArr addObject:modelFrame];
            }
            //            _HUD.hidden = YES;
            _dataArrLeft = myDataArr;
            [self.tableViewLeft reloadData];
            
        } failure:^(NSError *errorMessage) {
            HUD.hidden = YES;
            NSLog(@"广场接口请求Error ==%@",errorMessage);
        }];
        
    }
    
    return _dataArrLeft;
}

- (NSArray *)dataArrRight{

    if (!_dataArrRight) {
        
        NSMutableArray * myDataArr = [NSMutableArray array];
        MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.dimBackground=YES;
        
        [self.view bringSubviewToFront:HUD];
        
        [CloudLogin getPlazaDataWithType:[NSString stringWithFormat:@"%d",DataTypeClassical] page:@"1" count:@"5" success:^(NSDictionary *responseObject) {
            
            NSLog(@"经典绘本：==%@",responseObject);
            HUD.hidden = YES;
            NSArray * dataArr = responseObject[@"galleries"];
            
            for (NSDictionary * dic in dataArr) {
                
                PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                
                PlazaDataFrame * modelFrame = [[PlazaDataFrame alloc] init];
                modelFrame.model = model;
                
                [myDataArr addObject:modelFrame];
            }
//            _HUD.hidden = YES;
            _dataArrRight = myDataArr;
            [self.tableViewRight reloadData];
            
        } failure:^(NSError *errorMessage) {
            HUD.hidden = YES;
            NSLog(@"广场接口请求Error ==%@",errorMessage);
        }];

    }
    
    return _dataArrRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTopView];
    [self dataArrRight];
    [self dataArrLeft];
    
    
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
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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

    if (tableView.tag == TableViewRight) {
        return (_dataArrRight) ? _dataArrRight.count : 0;
    }else{
        
        return (_dataArrLeft) ? _dataArrLeft.count : 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    PlazaDataFrame * dataF;
    
    if (tableView.tag == TableViewLeft) {
        dataF = [_dataArrLeft objectAtIndex:indexPath.row];
        return dataF.cellHeight;
    }else{
        dataF = [_dataArrRight objectAtIndex:indexPath.row];
        return dataF.cellHeight;
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PlazaDataFrame * dataF;
    
    if (tableView.tag == TableViewLeft) {
        dataF = [_dataArrLeft objectAtIndex:indexPath.row];
        
    }else{
        dataF = [_dataArrRight objectAtIndex:indexPath.row];
        
    }
    PlazaMainCell * cell = [PlazaMainCell cellWithTableView:tableView];
    
    cell.modelFrame = dataF;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int index1 = arc4random()%255;
    int index2 = arc4random()%255;
    int index3 = arc4random()%255;
    
    cell.backgroundColor = Color(index1, index2, index3);
    
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
