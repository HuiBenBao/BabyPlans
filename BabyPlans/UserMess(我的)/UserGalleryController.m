//
//  UserGalleryController.m
//  BabyPlans
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserGalleryController.h"
#import "PlazaDataFrame.h"
#import "PlazaMainCell.h"
#import "GalleryArrView.h"
#import "CommentController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

NSString * const Count = @"10";  //每页显示数据

@interface UserGalleryController ()<UITableViewDelegate,UITableViewDataSource,PlazaMainCellDelegate,CommentControllerDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSString * userID;

/**
 *  查看大图时的背景view
 */
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) GalleryArrView * galleryView;
@end

@implementation UserGalleryController

- (instancetype)initWithUserID:(NSString *)userID{

    if (self = [super init]) {
        self.userID = userID;
        
    }
    
    return self;
}

- (NSArray *)dataSource{

    if (!_dataSource) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        
        //初始化请求页码
        _page = 1;
        [CloudLogin getPlazaDataWithType:nil page:[NSString stringWithFormat:@"%d",_page] count:Count userID:_userID status:0 success:^(NSDictionary *responseObject) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            
            NSLog(@"绘本数据==%@",responseObject);
            
            int status = [responseObject[@"status"] intValue];
            if (status == 0) {
                
                NSArray * dataArr = responseObject[@"galleries"];
                NSMutableArray * tempArr = [NSMutableArray array];
                
                for (NSDictionary * dic in dataArr) {
                    
                    PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                    
                    PlazaDataFrame * modelFrame = [[PlazaDataFrame alloc] init];
                    modelFrame.model = model;
                    
                    [tempArr addObject:modelFrame];
                }
                
                _dataSource = tempArr;
                
                [self.tableView.mj_header setState:MJRefreshStateIdle];
                
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                
                [self.tableView reloadData];

            }else{
            
                [self.view poptips:responseObject[@"error"]];
            }
            
        } failure:^(NSError *errorMessage) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            [self.view poptips:@"网络异常，请稍后再试"];
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

- (void)removeBackView{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
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

- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.title = @"绘本列表";

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self refreshData];
    }];
    
    MJRefreshStateHeader * header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _dataSource = nil;
        [self dataSource];
    }];
    
    
    footer.stateLabel.hidden = YES;
    
    _tableView.mj_header = header;
    _tableView.mj_footer = footer;

    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    [self dataSource];
}

/**
 *  获取下一页数据
 */
- (void)refreshData{
    
    _page++;
    [CloudLogin getPlazaDataWithType:nil page:[NSString stringWithFormat:@"%d",_page] count:Count userID:_userID status:0 success:^(NSDictionary *responseObject) {
        
        if ([responseObject[@"status"] intValue] == 0) {
            NSArray * dataArr = responseObject[@"galleries"];
            
            if (dataArr.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                _tableView.mj_footer.hidden = YES;
                
            }else{
                [_tableView.mj_footer setState:MJRefreshStateIdle];
                
                
            }
            
            NSMutableArray * myDataArr = [NSMutableArray arrayWithArray:_dataSource];
            for (NSDictionary * dic in dataArr) {
                
                PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                
                PlazaDataFrame * modelFrame = [[PlazaDataFrame alloc] init];
                modelFrame.model = model;
                
                [myDataArr addObject:modelFrame];
            }
            _dataSource = myDataArr;
            [_tableView reloadData];
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
    
    return _dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlazaDataFrame * dataF = [_dataSource objectAtIndex:indexPath.row];
    return dataF.cellHeight;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlazaDataFrame * dataF = [_dataSource objectAtIndex:indexPath.row];
    

    PlazaMainCell * cell = [PlazaMainCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.modelFrame = dataF;
    
    cell.delegate = self;
    
    return cell;
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
        
        //隐藏时间栏
        [UIApplication sharedApplication].statusBarHidden = YES;
        
        //设置播放期间禁止锁屏
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        
        _backView.frame = KScreenRect;
        _backView.alpha = 0.8;
        
        
        CGFloat gallArrH = KScreenHeight;
        _galleryView.frame = CGRectMake(0, 0, KScreenWidth, gallArrH);
        _galleryView.alpha = 1;
    }];
    
}
/**
 *  cell底部四个按钮点击方法
 *
 *  @param index 按钮编号
 */
- (void)clickBottomBtn:(UIButton *)button galleryID:(NSString *)galleryID indexPath:(NSIndexPath *)indexPath tableTag:(NSInteger)tableTag{
    
    NSInteger index = button.tag;
    
    PlazaDataFrame * plazaFrame = [_dataSource objectAtIndex:indexPath.row];
    PlazaDataModel * model = plazaFrame.model;
    
    if (index==0) { //收藏
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        
        [CloudLogin likeWithGalleryID:galleryID type:@"1" success:^(NSDictionary *responseObject) {
            NSLog(@"收藏----%@",responseObject);
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            int status = [responseObject[@"status"] intValue];
            if (status==0) {
                [self.view poptips:@"收藏成功"];
                
                //修改并刷新数据
                model.likeCount = [NSString stringWithFormat:@"%d",[model.likeCount intValue]+1];
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else if(status==2){//取消点赞
                
                [CloudLogin likeWithGalleryID:galleryID type:@"0" success:^(NSDictionary *responseObject) {
                    NSLog(@"取消收藏----%@",responseObject);
                    
                    int status = [responseObject[@"status"] intValue];
                    if (status==0) {
                        [self.view poptips:@"已取消收藏"];
                        
                        //修改并刷新数据
                        model.likeCount = [NSString stringWithFormat:@"%d",[model.likeCount intValue]-1];
                        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        
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
            NSLog(@"收藏----%@",errorMessage);
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
                        
                        NSString * mess = (following == 1) ? @"关注成功" : @"已取消";
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
        
        [self shareGalleryWithModel:model];
        
    }
    
}
#pragma ---mark------CommentControllerDelegate

- (void)reloadPlazaDataWithGalleryID:(NSString *)galleryID tabTag:(NSInteger)tabTag indexPath:(NSIndexPath *)indexPath{
    
    PlazaDataFrame * plazaFrame = [_dataSource objectAtIndex:indexPath.row];
    PlazaDataModel * model = plazaFrame.model;
    int totalNum = [model.commentCount intValue]+1;
    model.commentCount = [NSString stringWithFormat:@"%d",totalNum];
    
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}
/**
 *  分享图集
 */
- (void)shareGalleryWithModel:(PlazaDataModel *)model{

    if (model.minImg) {
        
        NSString *Urlstr = [NSString stringWithFormat:@"%@%@",GALLERY_PAGE,model.galleryID];
        //获取缩略图和正常像素图
        UIImage * thumbImg = [UIImage imageWithURLString:model.minImg];
        UIImage * upImage = [UIImage imageWithURLString:model.coverImg];
        
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKEnableUseClientShare];
        [shareParams SSDKSetupShareParamsByText:model.content
                                         images:upImage
                                            url:[NSURL URLWithString:Urlstr]
                                          title:@"看绘本，上绘本宝"
                                           type:SSDKContentTypeAuto];
        
        //                [shareParams SSDKSetupSinaWeiboShareParamsByText:model.content title:@"看绘本，上绘本宝" image:upImage url:[NSURL URLWithString:Urlstr] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeImage];
        //定制QQ分享内容
        [shareParams SSDKSetupQQParamsByText:model.content title:@"看绘本，上绘本宝" url:[NSURL URLWithString:Urlstr] audioFlashURL:[NSURL URLWithString:model.galleryBase] videoFlashURL:nil thumbImage:thumbImg image:upImage type:SSDKContentTypeAudio forPlatformSubType:SSDKPlatformSubTypeQQFriend];
        
        //定制QQ空间分享内容
        [shareParams SSDKSetupQQParamsByText:model.content title:@"看绘本，上绘本宝" url:[NSURL URLWithString:Urlstr] audioFlashURL:[NSURL URLWithString:model.galleryBase] videoFlashURL:nil thumbImage:thumbImg image:upImage type:SSDKContentTypeAudio forPlatformSubType:SSDKPlatformSubTypeQZone];
        
        // 定制微信好友的分享内容
        [shareParams SSDKSetupWeChatParamsByText:model.content
                                           title:@"看绘本，上绘本宝"
                                             url:[NSURL URLWithString:Urlstr]
                                      thumbImage:thumbImg
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
                                      thumbImage:thumbImg
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

@end
