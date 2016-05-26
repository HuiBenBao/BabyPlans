//
//  UserCollectController.m
//  BabyPlans
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserCollectController.h"
#import "CollectCell.h"
#import "GalleryArrView.h"

#define DataCount 10

@interface UserCollectController ()<UITableViewDelegate,UITableViewDataSource,CollectCellDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,assign) int page;

/**
 *  查看大图时的背景view
 */
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) GalleryArrView * galleryView;
@end

@implementation UserCollectController

- (NSArray *)dataSource{

    if (!_dataSource) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        
        _page = 1;
        
        NSMutableArray * tempArr = [NSMutableArray array];
        [CloudLogin UserCollectWihtPage:[NSString stringWithFormat:@"%d",_page] count:[NSString stringWithFormat:@"%d",DataCount] Success:^(NSDictionary *responseObject) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            
            int status = [responseObject[@"status"] intValue];
            if (status == 0) {
                
                if (ValidArray([responseObject objectForKey:@"galleries"])) {
                    
                    NSArray *galleries = [responseObject objectForKey:@"galleries"];
                    
                    for (NSDictionary * dic in galleries) {
                        
                        CollectModel * model = [CollectModel valueWithDic:dic];
                        CollectFrame * dataF = [[CollectFrame alloc] init];
                        dataF.model = model;
                        
                        [tempArr addObject:dataF];
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
- (UIView *)backView{
    
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
        [_backView addTarget:self action:@selector(removeBackView)];
    }
    return _backView;
}

- (GalleryArrView *)galleryView{
    
    if (!_galleryView) {
        _galleryView = [[GalleryArrView alloc] init];
        [_galleryView addTarget:self action:@selector(removeBackView)];
    }
    
    return _galleryView;
}

- (void)viewDidLoad{

    [super viewDidLoad];

    self.view.backgroundColor = ViewBackColor;
    self.title = @"我的收藏";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNavBarHeight, KScreenWidth, KScreenHeight-KNavBarHeight) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self refreshNextPage];
    }];
    
        
    
    footer.stateLabel.hidden = YES;
    
    _tableView.mj_footer = footer;

    
    [self.view addSubview:_tableView];
    
    //数据初始化
    [self dataSource];
}

#pragma ---mark------UItableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CollectFrame * dataF = [_dataSource objectAtIndex:indexPath.row];
    
    return dataF.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CollectFrame * dataF = [_dataSource objectAtIndex:indexPath.row];
    CollectCell * cell = [CollectCell cellWithTableView:tableView indexPath:indexPath];
    cell.modelFrame = dataF;
    cell.delegate = self;
    
    return cell;
}

#pragma ----mark-----UITableVIewDelegate
/**
 *  先要设Cell可编辑
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
    CollectFrame * dataF = [_dataSource objectAtIndex:indexPath.row];
    
    [CloudLogin likeWithGalleryID:dataF.model.galleryID type:@"0" success:^(NSDictionary *responseObject) {
        NSLog(@"取消收藏----%@",responseObject);
        
        int status = [responseObject[@"status"] intValue];
        if (status==0) {
            
            NSMutableArray * dataArr = [NSMutableArray arrayWithArray:_dataSource];
            
            [dataArr removeObjectAtIndex:indexPath.row];
            
            _dataSource = dataArr;
            
            [self.tableView reloadData];

        }else
            [self.view poptips:responseObject[@"error"]];
        
    } failure:^(NSError *errorMessage) {
        NSLog(@"点赞----%@",errorMessage);
    }];

}


//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消收藏";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma ----mark-----获取下一页数据
/**
 *  获取下一页数据
 */
- (void)refreshNextPage{
    
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:_dataSource];

    _page++;
    
    [CloudLogin UserCollectWihtPage:[NSString stringWithFormat:@"%d",_page] count:[NSString stringWithFormat:@"%d",DataCount] Success:^(NSDictionary *responseObject) {
        
        int status = [responseObject[@"status"] intValue];
        if (status == 0) {
            
            if (ValidArray([responseObject objectForKey:@"galleries"])) {
                
                NSArray *galleries = [responseObject objectForKey:@"galleries"];
                
                [_tableView.mj_footer setState:MJRefreshStateIdle];

                for (NSDictionary * dic in galleries) {
                    
                    CollectModel * model = [CollectModel valueWithDic:dic];
                    CollectFrame * dataF = [[CollectFrame alloc] init];
                    dataF.model = model;
                    
                    [tempArr addObject:dataF];
                }
                
                _dataSource = tempArr;
                [self.tableView reloadData];
            }else{
                
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                _tableView.mj_footer.hidden = YES;

            }
            
            
        }else{
            
            [self.view poptips:responseObject[@"error"]];
        }
    } failure:^(NSError *errorMessage) {
        
        [self.view poptips:@"网络异常"];
    }];
    
}

#pragma ----mark----CollectCellDelegate

- (void)getImageArrWithID:(NSString *)galleryID{

    //弹窗
    self.galleryView.galleryID = galleryID;
    self.backView.frame = CGRectMake(KScreenWidth/2, KScreenHeight/2, 0, 0);
    self.galleryView.frame = CGRectMake(KScreenWidth/2, KScreenHeight/2, 0, 0);
    
    [[[UIApplication sharedApplication].delegate window].rootViewController.view  addSubview:_backView];
    [[[UIApplication sharedApplication].delegate window].rootViewController.view  addSubview:_galleryView];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [UIApplication sharedApplication].statusBarHidden = YES;
        
        _backView.frame = KScreenRect;
        _backView.alpha = 0.8;
        
        CGFloat gallArrH = KScreenHeight;
        _galleryView.frame = CGRectMake(0, 0, KScreenWidth, gallArrH);
        _galleryView.alpha = 1;
    }];

}

- (void)removeBackView{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        _backView.alpha = 0;
        _galleryView.alpha = 0;
        _backView.frame = CGRectMake(KScreenWidth/2, KScreenHeight/2, 0, 0);
        _galleryView.frame = CGRectMake(KScreenWidth/2, KScreenHeight/2, 0, 0);
        
        
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        [_galleryView removeFromSuperview];
        _galleryView = nil;
        
    }];
}
@end
