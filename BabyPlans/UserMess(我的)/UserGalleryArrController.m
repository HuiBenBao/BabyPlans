//
//  UserGalleryArrController.m
//  BabyPlans
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserGalleryArrController.h"
#import "FWBTitleScrollView.h"
#import "UserGalleryCell.h"
#import "GalleryArrView.h"

static const int DataCount = 10;
typedef enum : NSUInteger {
    StatusSuccess,
    StatusFailue,
    StatusIng,
} Status;

@interface UserGalleryArrController ()<FWBTitleScrollDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) FWBTitleScrollView * scrollView;

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,strong) NSArray * dataSource1;
@property (nonatomic,strong) NSArray * dataSource2;

@property (nonatomic,assign) int page;
@property (nonatomic,assign) int page1;
@property (nonatomic,assign) int page2;

@property (nonatomic,assign) Status status;

/**
 *  查看大图时的背景view
 */
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) GalleryArrView * galleryView;
@end

@implementation UserGalleryArrController

#pragma ---mark-----数据懒加载
- (NSArray *)dataSource{
    
    if (!_dataSource) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        
        _page = 1;
        
        NSMutableArray * tempArr = [NSMutableArray array];
        [CloudLogin getPlazaDataWithType:nil page:[NSString stringWithFormat:@"%d",_page] count:[NSString stringWithFormat:@"%d",DataCount] userID:[defaults valueForKey:@"token"] status:StatusSuccess success:^(NSDictionary *responseObject) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            
            int status = [responseObject[@"status"] intValue];
            if (status == 0) {
                
                if (ValidArray([responseObject objectForKey:@"galleries"])) {
                    
                    NSArray *galleries = [responseObject objectForKey:@"galleries"];
                    
                    for (NSDictionary * dic in galleries) {
                        
                        PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                        
                        [tempArr addObject:model];
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
- (NSArray *)dataSource2{
    
    if (!_dataSource2) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        
        _page2 = 1;
        _status = StatusIng;
        NSMutableArray * tempArr = [NSMutableArray array];
        [CloudLogin getPlazaDataWithType:nil page:[NSString stringWithFormat:@"%d",_page2] count:[NSString stringWithFormat:@"%d",DataCount] userID:[defaults valueForKey:@"token"] status:StatusIng success:^(NSDictionary *responseObject) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            
            int status = [responseObject[@"status"] intValue];
            if (status == 0) {
                
                if (ValidArray([responseObject objectForKey:@"galleries"])) {
                    
                    NSArray *galleries = [responseObject objectForKey:@"galleries"];
                    
                    for (NSDictionary * dic in galleries) {
                        
                        PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                        
                        
                        [tempArr addObject:model];
                    }
                    
                    _dataSource2 = tempArr;
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
    return _dataSource2;
}
- (NSArray *)dataSource1{
    
    if (!_dataSource1) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        
        _page1 = 1;
        _status = StatusFailue;
        NSMutableArray * tempArr = [NSMutableArray array];
        [CloudLogin getPlazaDataWithType:nil page:[NSString stringWithFormat:@"%d",_page1] count:[NSString stringWithFormat:@"%d",DataCount] userID:[defaults valueForKey:@"token"] status:StatusFailue success:^(NSDictionary *responseObject) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            
            int status = [responseObject[@"status"] intValue];
            if (status == 0) {
                
                if (ValidArray([responseObject objectForKey:@"galleries"])) {
                    
                    NSArray *galleries = [responseObject objectForKey:@"galleries"];
                    
                    for (NSDictionary * dic in galleries) {
                        
                        PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                        
                        
                        [tempArr addObject:model];
                    }
                    
                    _dataSource1 = tempArr;
                    
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
    return _dataSource1;
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
#pragma ---mark------界面加载

- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.title = @"我的绘本";
    
    [self addTitleView];
    [self addTableView];
}
/**
 *  设置绘本分类（标题视图）
 */
- (void)addTitleView{
    
    self.scrollView = [[FWBTitleScrollView alloc]initWithFrame: CGRectMake(0,KNavBarHeight, KScreenWidth,40*SCREEN_WIDTH_RATIO55)];
    self.scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
}
/**
 *  数据展示视图
 */
- (void)addTableView{

    //设置默认状态
    _status = StatusSuccess;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.scrollView.bottom, KScreenWidth, KScreenHeight-self.scrollView.bottom) style:UITableViewStylePlain];
    
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

#pragma ----mark-----FWBTitleScrollDelegate
- (void)clickTitleButton:(UIButton *)btn{

    // 改变按钮状态，滚动标题下面的滚动条
    [self scrollTitleBarWithIndex:btn.tag];
    // 跳转到指定页面
//    [self scrollToItemWithIndex:btn.tag];
}

- (void)scrollTitleBarWithIndex:(NSInteger)index{
    
    for (UIButton * sender in self.scrollView.btnArr) {
        sender.selected = NO;
    }
    
    // 滚动标题下面的滚动条
    UIButton * btn = self.scrollView.btnArr[index];
    
    btn.selected = YES;
    
    self.status = btn.tag;
    switch (_status) {
        case StatusSuccess:
            [self dataSource];
            break;
        case StatusFailue:
            [self dataSource1];
            break;
        case StatusIng:
            [self dataSource2];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
    
    CGRect barFrame = self.scrollView.scrollBar.frame;
    barFrame.origin.x = btn.frame.origin.x + btn.titleLabel.frame.origin.x;
    barFrame.size.width = btn.titleLabel.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.scrollBar.frame = barFrame;
    }];
}

#pragma ---mark------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return (_status == StatusSuccess) ? _dataSource.count : (_status == StatusIng) ? _dataSource2.count : _dataSource1.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * dataArr = (_status == StatusSuccess) ? _dataSource : (_status == StatusIng) ? _dataSource2 : _dataSource1;
    PlazaDataModel * model = [dataArr objectAtIndex:indexPath.row];
    
    UserGalleryCell * cell = [UserGalleryCell cellWithTableView:tableView indexPath:indexPath];
    cell.model = model;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserGalleryCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    PlazaDataModel * model = cell.model;
    
    [self getImageArrWithID:model.galleryID];
    
}

#pragma ----mark-----获取下一页数据
/**
 *  获取下一页数据
 */
- (void)refreshNextPage{
    
    int page;
    switch (_status) {
        case StatusSuccess:
            _page++;
            page = _page;
            break;
        case StatusFailue:
            _page1++;
            page = _page1;
            break;
        case StatusIng:
            _page2++;
            page = _page2;
            break;
        default:
            break;
    }
    NSArray * dataArr = (_status == StatusSuccess) ? _dataSource : (_status == StatusIng) ? _dataSource2 : _dataSource1;
    
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:dataArr];
    
    [CloudLogin getPlazaDataWithType:nil page:[NSString stringWithFormat:@"%d",page] count:[NSString stringWithFormat:@"%d",DataCount] userID:[defaults valueForKey:@"token"] status:_status success:^(NSDictionary *responseObject) {
        
        int status = [responseObject[@"status"] intValue];
        if (status == 0) {
            
            if (ValidArray([responseObject objectForKey:@"galleries"])) {
                
                NSArray *galleries = [responseObject objectForKey:@"galleries"];
                
                [_tableView.mj_footer setState:MJRefreshStateIdle];
                
                for (NSDictionary * dic in galleries) {
                    
                    PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                    
                    [tempArr addObject:model];
                }
                switch (_status) {
                    case StatusSuccess:
                        _dataSource = tempArr;
                        break;
                    case StatusFailue:
                        _dataSource1 = tempArr;
                        break;
                    case StatusIng:
                        _dataSource2 = tempArr;
                        break;
                    default:
                        break;
                }

                [self.tableView reloadData];
            }else{
                
                [_tableView.mj_footer setState:MJRefreshStateIdle];
                
            }
            
            
        }else{
            
            [self.view poptips:responseObject[@"error"]];
        }
    } failure:^(NSError *errorMessage) {
        
        [self.view poptips:@"网络异常"];
    }];
    
}

/**
 *  展示图集
 *
 *  @param galleryID 图集id
 */
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

@end
