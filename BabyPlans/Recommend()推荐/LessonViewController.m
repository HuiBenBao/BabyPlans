//
//  LessonViewController.m
//  BabyPlans
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LessonViewController.h"
#import "LessonCell.h"

#define CountInOnePage 10    //每页显示数据个数

@interface LessonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray * dataArr;

@property (nonatomic,strong) UITableView * tableView;


@property (nonatomic,assign) int page;

@end


@implementation LessonViewController


- (NSArray *)dataArr{

    if (!_dataArr) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        _page = 1;
        NSMutableArray * tempArr = [NSMutableArray array];
        [CloudLogin getLessonCount:[NSString stringWithFormat:@"%d",CountInOnePage] Page:[NSString stringWithFormat:@"%d",_page] Success:^(NSDictionary *responseObject) {
            
            NSLog(@"课程列表====%@",responseObject);
            hud.hidden = YES;
            
            int status = [responseObject[@"status"] intValue];
            
            if (status==0) {
                NSArray * lessons = responseObject[@"lessons"];
                
                for (NSDictionary * dic in lessons) {
                    LessonListModel * model = [LessonListModel valueWithDic:dic];
                    
                    [tempArr addObject:model];
                }
                
                _dataArr = tempArr;
                self.tableView.mj_header.state = MJRefreshStateIdle;
                [self.tableView reloadData];
            }else{
            
                [self.view poptips:responseObject[@"error"]];
            }
        } failure:^(NSError *errorMessage) {
            hud.hidden = YES;
            [self.view requsetFaild];
        }];
    }
    return _dataArr;
}
/**
 *  上拉加载更多
 */
- (void)getMoreData{

    _page++;
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:_dataArr];
    [CloudLogin getLessonCount:[NSString stringWithFormat:@"%d",CountInOnePage] Page:[NSString stringWithFormat:@"%d",_page] Success:^(NSDictionary *responseObject) {
        
        int status = [responseObject[@"status"] intValue];
        
        if (status==0) {
            NSArray * lessons = responseObject[@"lessons"];
            
            if (lessons.count==0) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }else{
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }
            
            for (NSDictionary * dic in lessons) {
                LessonListModel * model = [LessonListModel valueWithDic:dic];
                
                [tempArr addObject:model];
            }
            
            _dataArr = tempArr;
            [self.tableView reloadData];
        }
    } failure:^(NSError *errorMessage) {
        [self.view requsetFaild];
    }];

}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"嘉庆叔叔说绘本";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        self.dataArr = nil;
        [self dataArr];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
       
        [self getMoreData];
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    //数据请求
    [self dataArr];
}

#pragma -----mark-----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90*SCREEN_WIDTH_RATIO55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LessonListModel * model = [_dataArr objectAtIndex:indexPath.row];
    
    LessonCell * cell = [LessonCell cellWithTableView:tableView];
    cell.model = model;
    
    return cell;
}
@end
