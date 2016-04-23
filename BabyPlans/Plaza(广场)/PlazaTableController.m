//
//  PlazaTableController.m
//  BabyPlans
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlazaTableController.h"
#import "PlazaTopView.h"
#import "PlazaMainCell.h"
#import "GalleryArrView.h"
#import "LoginViewController.h"
#import "CommentController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>



enum{
    TableViewLeft,
    TableViewRight
} TableView;

enum{
    DataTypeClassical, //经典绘本
    DataTypeOrginal //原创绘本

} DataType;


#define tableHeaderHeight (45*SCREEN_WIDTH_RATIO55)
#define TabbleViewCount 2  //tabbleView的个数

#define DataCount @"5" //每页请求显示个数

@interface PlazaTableController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PlazaTopDelegate,PlazaMainCellDelegate,CommentControllerDelegate>

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
/**
 *  查看大图时的背景view
 */
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) GalleryArrView * galleryView;

@end

@implementation PlazaTableController

#pragma ---mark---懒加载方法
- (NSArray *)dataArrLeft{
    
    if (!_dataArrLeft) {
        
        NSMutableArray * myDataArr = [NSMutableArray array];
        MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.dimBackground=YES;
        
        [self.view bringSubviewToFront:HUD];
        
        self.pageClassical = 1;
        
        [CloudLogin getPlazaDataWithType:[NSString stringWithFormat:@"%d",DataTypeOrginal] page:[NSString stringWithFormat:@"%d",_pageClassical] count:DataCount success:^(NSDictionary *responseObject) {
            
            NSLog(@"经典绘本：==%@",responseObject);
            HUD.hidden = YES;
            
            if ([responseObject[@"status"] intValue] == 0) {
                
                NSArray * dataArr = responseObject[@"galleries"];
                
                for (NSDictionary * dic in dataArr) {
                    
                    PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                    
                    PlazaDataFrame * modelFrame = [[PlazaDataFrame alloc] init];
                    modelFrame.model = model;
                    
                    [myDataArr addObject:modelFrame];
                }
                //            _HUD.hidden = YES;
                _dataArrLeft = myDataArr;
                
                [self.tableViewLeft.mj_header setState:MJRefreshStateIdle];
                [self.tableViewLeft reloadData];

            }
            
        } failure:^(NSError *errorMessage) {
            HUD.hidden = YES;
            NSLog(@"广场接口请求Error ==%@",errorMessage);
        }];
        
    }
    
    return _dataArrLeft;
}

- (NSArray *)dataArrRight{

    if (!_dataArrRight) {
        
        MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.dimBackground=YES;
        
        [self.view bringSubviewToFront:HUD];
        
        self.pageOrginal = 1;
        
        NSMutableArray * myDataArr = [NSMutableArray array];

        [CloudLogin getPlazaDataWithType:[NSString stringWithFormat:@"%d",DataTypeClassical] page:[NSString stringWithFormat:@"%d",_pageOrginal] count:DataCount success:^(NSDictionary *responseObject) {
            
            NSLog(@"原创绘本：==%@",responseObject);
            HUD.hidden = YES;
            
            if ([responseObject[@"status"] intValue] == 0) {
                NSArray * dataArr = responseObject[@"galleries"];
                
                for (NSDictionary * dic in dataArr) {
                    
                    PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                    
                    PlazaDataFrame * modelFrame = [[PlazaDataFrame alloc] init];
                    modelFrame.model = model;
                    
                    [myDataArr addObject:modelFrame];
                }
                //            _HUD.hidden = YES;
                _dataArrRight = myDataArr;
                
                [self.tableViewRight.mj_header setState:MJRefreshStateIdle];
                [self.tableViewRight reloadData];
            }
            
            
        } failure:^(NSError *errorMessage) {
            HUD.hidden = YES;
            
            [self.view requsetFaild];
            NSLog(@"广场接口请求Error ==%@",errorMessage);
        }];

    }
    
    return _dataArrRight;
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
#pragma ---mark----viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTopView];
//    [self dataArrRight];
    [self dataArrLeft];
    
    
}
#pragma ----mark-----创建视图

- (void)createTopView{

    //顶部按钮
    self.topView = [[PlazaTopView alloc] initWithFrame:CGRectMake(0, KNavBarHeight, KScreenWidth, tableHeaderHeight)];
    self.topView.delegate = self;
    [self.view addSubview:_topView];
    
    //底层视图
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    _mainScrollView.backgroundColor = ColorI(0xffffff);
    _mainScrollView.contentSize = CGSizeMake(KScreenWidth*TabbleViewCount, 0);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    
    //将tabbleView添加到scrollerView上
    for (int i = 0; i < TabbleViewCount; i ++) {
        
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth*i, tableHeaderHeight, KScreenWidth, KScreenHeight-KNavBarHeight-tableHeaderHeight-KTabBarHeight) style:UITableViewStylePlain];
        
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
        
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self refreshWithTag:i];
        }];
        
        MJRefreshStateHeader * header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
//            [self refreshWithTag:i];
            CGFloat currentX = self.mainScrollView.contentOffset.x;
            currentX = currentX+KScreenWidth/2;
            
            int cuIndex = currentX/KScreenWidth;
            
//            self.topView.hidden = 1;
            
            if (cuIndex==0) {//左侧tableView
                self.dataArrLeft = nil;
                [self dataArrLeft];
            }else{
                self.dataArrRight = nil;
                [self dataArrRight];
            }
        }];
        
        
        footer.stateLabel.hidden = YES;
        
        tableView.mj_header = header;
        tableView.mj_footer = footer;
        tableView.mj_header.tag = tableView.tag;
        tableView.mj_footer.tag = tableView.tag;
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [self.mainScrollView addSubview:tableView];
        
        
    }
    
    //将topView移到顶层
    [self.view bringSubviewToFront:_topView];
}
/**
 *  获取下一页数据
 */
- (void)refreshWithTag:(NSInteger)tabViewTag{

    BOOL isLeftTable = (tabViewTag == TableViewLeft);
    int page = isLeftTable ? ++_pageClassical : ++_pageOrginal ;
    int type = isLeftTable ? DataTypeClassical : DataTypeOrginal;
    
   

    [CloudLogin getPlazaDataWithType:[NSString stringWithFormat:@"%d",type] page:[NSString stringWithFormat:@"%d",page] count:DataCount success:^(NSDictionary *responseObject) {
        
        NSArray * currentArr = isLeftTable ? _dataArrLeft : _dataArrRight;
        NSMutableArray * myDataArr = [NSMutableArray arrayWithArray:currentArr];
        UITableView * tableV = isLeftTable ? self.tableViewLeft : self.tableViewRight;
        
        if ([responseObject[@"status"] intValue] == 0) {
            NSArray * dataArr = responseObject[@"galleries"];
            
            if (dataArr.count == 0) {
                [tableV.mj_footer endRefreshingWithNoMoreData];
                tableV.mj_footer.hidden = YES;
                tableV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

            }else{
                [tableV.mj_footer setState:MJRefreshStateIdle];

                
            }
            for (NSDictionary * dic in dataArr) {
                
                PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                
                PlazaDataFrame * modelFrame = [[PlazaDataFrame alloc] init];
                modelFrame.model = model;
                
                NSLog(@"%@,%@",model.user.name,model.coverImg);
                
                [myDataArr addObject:modelFrame];
            }
            
            if (isLeftTable) {
                _dataArrLeft = myDataArr;
            }else{
            
                _dataArrRight = myDataArr;
            }
        
            
            [tableV reloadData];
        }
        
        
    } failure:^(NSError *errorMessage) {
        
        
        [self.view requsetFaild];
        NSLog(@"广场接口请求Error ==%@",errorMessage);
    }];

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
    PlazaMainCell * cell = [PlazaMainCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.modelFrame = dataF;
    
    cell.delegate = self;
    
    return cell;
}
#pragma mark---------ScrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (self.mainScrollView == scrollView) {
        CGFloat currentX = scrollView.contentOffset.x;
        currentX = currentX+KScreenWidth/2;
        
        int index = currentX/KScreenWidth;
        
        [self.topView selectAtIndex:index];
        
        if (!_dataArrRight && index==TableViewRight) {
            [self dataArrRight];
        }
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
    
    if (!_dataArrRight) {
        [self dataArrRight];
    }
}

#pragma ---mark--PlazaMainCellDelegate
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

        CGFloat gallArrH = KScreenHeight*2/3;
        _galleryView.frame = CGRectMake(20, KScreenHeight/8, KScreenWidth-40, gallArrH);
        _galleryView.alpha = 1;
    }];
    
}
/**
 *  cell底部四个按钮点击方法
 *
 *  @param index 按钮编号
 */
- (void)clickBottomBtn:(UIButton *)button galleryID:(NSString *)galleryID indexPath:(NSIndexPath *)indexPath tableTag:(NSInteger)tableTag{

    if (![defaults objectForKey:@"session"]) {//未登录
        
        [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
    }else{
        
        NSInteger index = button.tag;
        
        NSArray * dataArr = (tableTag==TableViewLeft) ? self.dataArrLeft : self.dataArrRight;
        PlazaDataFrame * plazaFrame = [dataArr objectAtIndex:indexPath.row];
        PlazaDataModel * model = plazaFrame.model;
        UITableView * tableView = (tableTag==TableViewLeft) ? self.tableViewLeft : self.tableViewRight;
        
        
        if (index==0) { //点赞
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = YES;

            [CloudLogin likeWithGalleryID:galleryID type:@"1" success:^(NSDictionary *responseObject) {
                NSLog(@"点赞----%@",responseObject);
                
                hud.hidden = YES;
                [hud removeFromSuperview];
                int status = [responseObject[@"status"] intValue];
                if (status==0) {
                    [self.view poptips:@"点赞成功"];
                    
                    //修改并刷新数据
                    model.likeCount = [NSString stringWithFormat:@"%d",[model.likeCount intValue]+1];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else if(status==2){//取消点赞
                    
                    [CloudLogin likeWithGalleryID:galleryID type:@"0" success:^(NSDictionary *responseObject) {
                        NSLog(@"取消点赞----%@",responseObject);
                        
                        int status = [responseObject[@"status"] intValue];
                        if (status==0) {
                            [self.view poptips:@"已取消点赞"];
                            
                            //修改并刷新数据
                            model.likeCount = [NSString stringWithFormat:@"%d",[model.likeCount intValue]-1];
                            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                        }else
                            [self.view poptips:responseObject[@"error"]];
                        
                    } failure:^(NSError *errorMessage) {
                        NSLog(@"点赞----%@",errorMessage);
                    }];
                }else
                    [self.view poptips:responseObject[@"error"]];
                
            } failure:^(NSError *errorMessage) {
                
                hud.hidden = YES;
                [hud removeFromSuperview];
                NSLog(@"点赞----%@",errorMessage);
            }];
            
        }else if (index == 1){//评论

            CommentController * commentVC = [CommentController commentWithGalleryID:galleryID tabTag:(int)tableTag];
            commentVC.indexPath = indexPath;
            commentVC.delegate = self;
            
            [self.navigationController pushViewController:commentVC animated:YES];
            
        }else if (index==2){//关注
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = YES;
            
            [CloudLogin attentionToUserID:model.user.userID type:nil success:^(NSDictionary *responseObject) {
                NSLog(@"%@",responseObject);
                int status = [responseObject[@"status"] intValue];
                
                hud.hidden = YES;
                [hud removeFromSuperview];
                
                if (status==0) {
                    
                    int following = [responseObject[@"following"] intValue];
                    
                    following = (following==0) ? 1 : 0;
                    
                    [CloudLogin attentionToUserID:model.user.userID type:[NSString stringWithFormat:@"%d",following] success:^(NSDictionary *responseObject) {
                        int reslut = [responseObject[@"status"] intValue];
                        NSLog(@"------%@",responseObject);
                        if (reslut==0) {
                                
                            NSString * mess = (following == 0) ? @"关注成功" : @"已取消";
                            [self.view poptips:mess];
                        }
                    } failure:nil];
                    
                    
                }
                
            } failure:^(NSError *errorMessage) {
                
                hud.hidden = YES;
                [hud removeFromSuperview];
                NSLog(@"%@",errorMessage);
            }];
        }else if (index==3){//分享
            
            NSString *Urlstr = [NSString stringWithFormat:@"%@%@",GALLERY_PAGE,model.galleryID];
            
            if (model.coverImg) {
                
                
                //获取图片
                UIImage * littleImg = [UIImage imageWithURLString:model.coverImg];
                
                //压缩
                float kCompressionQuality = 0.3;
                NSData *photo = UIImageJPEGRepresentation(littleImg, kCompressionQuality);
                
                UIImage * upImage = [UIImage imageWithData:photo];
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:model.content
                                                 images:upImage
                                                    url:[NSURL URLWithString:Urlstr]
                                                  title:@"看绘本，上绘本宝"
                                                type:SSDKContentTypeAuto];
                
                // 定制微信好友的分享内容
                [shareParams SSDKSetupWeChatParamsByText:model.content
                                                   title:@"看绘本，上绘本宝"
                                                   url:[NSURL URLWithString:Urlstr]
                                                   thumbImage:nil
                                                   image:upImage
                                                   musicFileURL:[NSURL URLWithString:model.galleryBase]
                                                    extInfo:nil
                                                    fileData:nil
                                                    emoticonData:nil
                                                    type:SSDKContentTypeAudio
                                      forPlatformSubType:SSDKPlatformSubTypeWechatSession];
                // 微信朋友圈
                [shareParams SSDKSetupWeChatParamsByText:model.content
                                                   title:@"看绘本，上绘本宝"
                                                     url:[NSURL URLWithString:Urlstr]
                                              thumbImage:nil
                                                   image:upImage
                                            musicFileURL:[NSURL URLWithString:model.galleryBase]
                                                 extInfo:nil
                                                fileData:nil
                                            emoticonData:nil
                                                    type:SSDKContentTypeAudio
                                      forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
                
                
                //2、分享（可以弹出我们的分享菜单和编辑界面）
                [ShareSDK showShareActionSheet:nil
                                         items:nil
                                   shareParams:shareParams
                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                               
                                    switch (state) {
                                        case SSDKResponseStateSuccess: {
                                            
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                            
                                               [alertView show];
                                               break;
                                        }
                                        case SSDKResponseStateFail:{
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                                [alert show];
                                                break;
                                        }
                                        default:
                                                break;
                                        }
                }];
                 
            }
            
        
        }
    }
}

- (void)reloadPlazaDataWithGalleryID:(NSString *)galleryID tabTag:(NSInteger)tabTag indexPath:(NSIndexPath *)indexPath{

    NSArray * dataArr = (tabTag==TableViewLeft) ? self.dataArrLeft : self.dataArrRight;
    PlazaDataFrame * plazaFrame = [dataArr objectAtIndex:indexPath.row];
    PlazaDataModel * model = plazaFrame.model;
    int totalNum = [model.commentCount intValue]+1;
    model.commentCount = [NSString stringWithFormat:@"%d",totalNum];
    
    UITableView * tableView = (tabTag==TableViewLeft) ? self.tableViewLeft : self.tableViewRight;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}
@end
