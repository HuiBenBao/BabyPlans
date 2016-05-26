//
//  UserFansController.m
//  BabyPlans
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserFansController.h"
#import "UserAttentionCell.h"

#define DataCount 10

@interface UserFansController ()

@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,assign) int page;


@end

@implementation UserFansController
- (NSArray *)dataSource{
    
    if (!_dataSource) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        
        _page = 1;
        
        NSMutableArray * tempArr = [NSMutableArray array];
        [CloudLogin UserFansWihtPage:[NSString stringWithFormat:@"%d",_page] count:[NSString stringWithFormat:@"%d",DataCount] Success:^(NSDictionary *responseObject) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            
            int status = [responseObject[@"status"] intValue];
            if (status == 0) {
                
                if (ValidArray([responseObject objectForKey:@"fans"])) {
                    
                    NSArray *galleries = [responseObject objectForKey:@"fans"];
                    
                    for (NSDictionary * dic in galleries) {
                        
                        FWBUserModel * user = [FWBUserModel valueWithDic:dic[@"user"]];
                        
                        [tempArr addObject:user];
                    }
                    
                    _dataSource = tempArr;
                    [self.tableView reloadData];
                    
                }
                
                
            }else{
                
                [self.view poptips:responseObject[@"error"]];
            }
        } failure:^(NSError *errorMessage) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            [self.view poptips:@"网络异常"];
        }];
    }
    return _dataSource;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewBackColor;
    self.title = @"我的粉丝";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self refreshNextPage];
    }];
    
    footer.stateLabel.hidden = YES;
    self.tableView.mj_footer = footer;
    
    
    //数据初始化
    [self dataSource];
    
}

#pragma ---mark------UItableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100*SCREEN_WIDTH_RATIO55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserAttentionCell * cell = [UserAttentionCell cellWithTableView:tableView indexPath:indexPath];
    
    FWBUserModel * user = [_dataSource objectAtIndex:indexPath.row];
    
    cell.model = user;
    
    return cell;
}

#pragma ----mark-----UITableVIewDelegate
/**
 *  先要设Cell可编辑
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
/**
 *  定义编辑样式
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/**
 *  进入编辑模式，按下出现的编辑按钮后
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FWBUserModel * user = [_dataSource objectAtIndex:indexPath.row];
    [CloudLogin attentionToUserID:user.userID type:@"0" success:^(NSDictionary *responseObject) {
        
        int status = [responseObject[@"status"] intValue];
        
        NSLog(@"取消关注 %@",responseObject);
        if (status==0) {
            
            NSMutableArray * dataArr = [NSMutableArray arrayWithArray:_dataSource];
            
            [dataArr removeObjectAtIndex:indexPath.row];
            
            _dataSource = dataArr;
            
            [self.tableView reloadData];
            
        }else{
            
            [self.view poptips:responseObject[@"error"]];
        }
    } failure:^(NSError *errorMessage) {
        [self.view poptips:@"网络异常"];
    }];
    
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消关注";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma ----mark-----下拉刷新

- (void)refreshNextPage{
    
    _page++;
    
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:_dataSource];
    [CloudLogin UserFansWihtPage:[NSString stringWithFormat:@"%d",_page] count:[NSString stringWithFormat:@"%d",DataCount] Success:^(NSDictionary *responseObject) {
        
        int status = [responseObject[@"status"] intValue];
        if (status == 0) {
            
            if (ValidArray([responseObject objectForKey:@"fans"])) {
                
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                
                NSArray *galleries = [responseObject objectForKey:@"fans"];
                
                for (NSDictionary * dic in galleries) {
                    
                    FWBUserModel * user = [FWBUserModel valueWithDic:dic[@"user"]];
                    
                    [tempArr addObject:user];
                }
                
                _dataSource = tempArr;
                [self.tableView reloadData];
                
            }else{
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.hidden = YES;
            }
            
            
        }else{
            
            [self.view poptips:responseObject[@"error"]];
        }
    } failure:^(NSError *errorMessage) {
        
        [self.view poptips:@"网络异常"];
    }];
    
}
@end
