//
//  UserGallerysController.m
//  BabyPlans
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserGallerysController.h"
#import "PlazaMainCell.h"
#import "GalleryArrView.h"
#import "CommentController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#define DataCount 5 //每页请求显示个数

@interface UserGallerysController ()<UITableViewDelegate,UITableViewDataSource,PlazaMainCellDelegate,CommentControllerDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,assign) int page;
/**
 *  查看大图时的背景view
 */
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) GalleryArrView * galleryView;
@end
@implementation UserGallerysController

- (NSArray *)dataSource{
    
    if (!_dataSource) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        
        _page = 1;
        
        NSMutableArray * tempArr = [NSMutableArray array];
        [CloudLogin getPlazaDataWithType:nil page:[NSString stringWithFormat:@"%d",_page] count:[NSString stringWithFormat:@"%d",DataCount] userID:[defaults valueForKey:@"token"] success:^(NSDictionary *responseObject) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            
            int status = [responseObject[@"status"] intValue];
            if (status == 0) {
                
                if (ValidArray([responseObject objectForKey:@"galleries"])) {
                    
                    NSArray *galleries = [responseObject objectForKey:@"galleries"];
                    
                    for (NSDictionary * dic in galleries) {
                        
                        PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                        
                        PlazaDataFrame * modelFrame = [[PlazaDataFrame alloc] init];
                        modelFrame.model = model;
                        
                        [tempArr addObject:modelFrame];
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
    
    self.view.backgroundColor = ViewBackColor;
    self.title = @"我的绘本";
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
    
    PlazaDataFrame * dataF = [_dataSource objectAtIndex:indexPath.row];
    
    return dataF.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlazaDataFrame * dataF = [_dataSource objectAtIndex:indexPath.row];
    PlazaMainCell * cell = [PlazaMainCell cellWithTableView:tableView indexPath:indexPath];
    cell.modelFrame = dataF;
    cell.delegate = self;
//    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

#pragma ----mark-----获取下一页数据
/**
 *  获取下一页数据
 */
- (void)refreshNextPage{
    
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:_dataSource];
    
    _page++;
    
    [CloudLogin getPlazaDataWithType:nil page:[NSString stringWithFormat:@"%d",_page] count:[NSString stringWithFormat:@"%d",DataCount] userID:[defaults valueForKey:@"token"] success:^(NSDictionary *responseObject) {
        
        int status = [responseObject[@"status"] intValue];
        if (status == 0) {
            
            if (ValidArray([responseObject objectForKey:@"galleries"])) {
                
                NSArray *galleries = [responseObject objectForKey:@"galleries"];
                
                [_tableView.mj_footer setState:MJRefreshStateIdle];
                
                for (NSDictionary * dic in galleries) {
                    
                    PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                    
                    PlazaDataFrame * modelFrame = [[PlazaDataFrame alloc] init];
                    modelFrame.model = model;
                    
                    [tempArr addObject:modelFrame];
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
            
            [self.view poptips:@"无法关注自己"];
            
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

- (void)reloadPlazaDataWithGalleryID:(NSString *)galleryID tabTag:(NSInteger)tabTag indexPath:(NSIndexPath *)indexPath{
    
    PlazaDataFrame * plazaFrame = [_dataSource objectAtIndex:indexPath.row];
    PlazaDataModel * model = plazaFrame.model;
    int totalNum = [model.commentCount intValue]+1;
    model.commentCount = [NSString stringWithFormat:@"%d",totalNum];
    
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}

@end
