//
//  UISearchViewController.m
//  BabyPlans
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomSearchBar.h"
#import "PlazaMainCell.h"
#import "GalleryArrView.h"
#import "LoginViewController.h"
#import "CommentController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "SearchViewController.h"


static NSString * DataCount = @"5";


@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PlazaMainCellDelegate,CommentControllerDelegate>

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,weak) CustomSearchBar * searchBar;
@property (nonatomic,weak) UIButton * cancelBtn;
@property (nonatomic,weak) UIView * coverBtn;

@property (nonatomic,strong) NSString * currentWord;//当前搜索内容


@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,assign) int page;

/**
 *  查看大图时的背景view
 */
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) GalleryArrView * galleryView;

@end

@implementation SearchViewController

- (NSArray *)dataSource{

    if (!_dataSource) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        
<<<<<<< HEAD
        
        [CloudLogin searchPalzaDataWithWord:_currentWord page:@1 count:DataCount success:^(NSDictionary *responseObject) {
=======
        _page = 1;
        [CloudLogin searchPalzaDataWithWord:_currentWord page:[NSNumber numberWithInteger:_page] count:DataCount success:^(NSDictionary *responseObject) {
>>>>>>> origin/master
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            
            NSMutableArray * myDataArr = [NSMutableArray array];
            if ([responseObject[@"status"] intValue] == 0) {
                
                NSArray * dataArr = responseObject[@"galleries"];
                
                for (NSDictionary * dic in dataArr) {
                    
                    PlazaDataModel * model = [PlazaDataModel valueWithDic:dic];
                    
                    PlazaDataFrame * modelFrame = [[PlazaDataFrame alloc] init];
                    modelFrame.model = model;
                    
                    [myDataArr addObject:modelFrame];
                }
                //            _HUD.hidden = YES;
                _dataSource = myDataArr;
                
                
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                
                [self.tableView reloadData];
                
                if (_dataSource.count > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }

            }else{
            
                [self.view poptips:responseObject[@"error"]];
            }
        } failure:^(NSError *errorMessage) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            [self.view requsetFaild];
            
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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTopView];
    [self createTableView];

}
/**
 *  定义导航栏上布局
 */
- (void)createTopView{
    
    // 创建返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_to_mainpage"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    
    
    //显示取消按钮
    CGFloat cancelW = 45*SCREEN_WIDTH_RATIO55;
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - cancelW- 30*SCREEN_WIDTH_RATIO55, 20, cancelW, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ColorI(0x8b8b8b) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT_ADAPTED_WIDTH(19);
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn = cancelBtn;
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] init];
    
    [rightitem setCustomView:cancelBtn];
    
    [self.navigationItem setRightBarButtonItem:rightitem animated:YES];
    
    // 搜索框
    CGFloat searchW = KScreenWidth - 90;
    CGFloat searchH = 90/3*SCREEN_WIDTH_RATIO55;
    CGFloat searchY = (44 - searchH)/2 + 20;
    CGFloat searchX = 45;
    
    CustomSearchBar *searchBar = [[CustomSearchBar alloc]initWithFrame:CGRectMake(searchX, searchY, searchW, searchH)];
    searchBar.delegate = self;
//    searchBar.placeholder = @"搜疾病";
    self.searchBar = searchBar;
    
    self.navigationItem.titleView = self.searchBar;
    

}
- (void)createTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNavBarHeight, KScreenWidth, KScreenHeight-KNavBarHeight) style:UITableViewStylePlain];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self refreshData];
    }];
    
    footer.stateLabel.hidden = YES;
    _tableView.mj_footer = footer;
    

}
/**
 *  返回上级界面
 */
- (void)backBtnClick{

    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  点击取消按钮
 */
- (void)cancelButtonClick:(UIButton *)sender{

    self.searchBar.text = nil;
    [self.coverBtn removeFromSuperview];
    [self.searchBar resignFirstResponder];
}

/**
 *  刷新数据
 */
- (void)refreshData{

    _page++;
    [CloudLogin searchPalzaDataWithWord:_currentWord page:[NSNumber numberWithInt:_page] count:DataCount success:^(NSDictionary *responseObject) {
        
        NSMutableArray * myDataArr = [NSMutableArray arrayWithArray:_dataSource];
        if ([responseObject[@"status"] intValue] == 0) {
            NSArray * dataArr = responseObject[@"galleries"];
            
            if (dataArr.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                _tableView.mj_footer.hidden = YES;
                _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                
            }else{
                [_tableView.mj_footer setState:MJRefreshStateIdle];
                
                
            }
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
        
    }];
}

#pragma ----mark-----UITableViewDelegate

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
    
    return cell;

}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{

     [self.tableView reloadData];
}

#pragma mark ---------------  UITextFieldDelegate ---------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = nil;
    _currentWord = nil;
    
    // 计算蒙板大小，添加蒙板
    [self createCoverBtnWithFrame:self.tableView.bounds];
    
    // 取消按钮文字变色
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelBtn.enabled = YES;
}

/**
 *  创建蒙板
 */
- (void)createCoverBtnWithFrame:(CGRect)rect
{
    UIButton *coverBtn = [[UIButton alloc] init];
    self.coverBtn = coverBtn;
    coverBtn.frame = rect;
    coverBtn.backgroundColor = [UIColor blackColor];
    coverBtn.alpha = 0.3;
    [coverBtn addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 将coverBtn显示在最前面
    [self.tableView addSubview:coverBtn];
    [self.view bringSubviewToFront:coverBtn];
}

/**
 *  点击背景时键盘消失
 */
- (void)coverClick:(UIButton *)btn{
    [btn removeFromSuperview];
    [self.searchBar resignFirstResponder];
    self.cancelBtn.enabled = NO;
    [self.cancelBtn setTitleColor:ColorI(0x8b8b8b) forState:UIControlStateNormal];
}



// 点搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.coverBtn removeFromSuperview];
    [self.searchBar resignFirstResponder];
    self.cancelBtn.enabled = NO;
    [self.cancelBtn setTitleColor:ColorI(0x8b8b8b) forState:UIControlStateNormal];
    
    if (self.dataSource) {
        self.dataSource = nil;
    }
    
    self.currentWord = [textField.text trim];
    [self dataSource];
    
    return YES;
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
    
    if (!(ValidStr([defaults objectForKey:@"session"]))) {//未登录
        
        [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
    }else{
        
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
                    model.isCollect = YES;
                    
                    
                    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else if(status==2){//取消收藏
                    
                    [CloudLogin likeWithGalleryID:galleryID type:@"0" success:^(NSDictionary *responseObject) {
                        NSLog(@"取消收藏----%@",responseObject);
                        
                        int status = [responseObject[@"status"] intValue];
                        if (status==0) {
                            [self.view poptips:@"已取消收藏"];
                            
                            //修改并刷新数据
                            model.likeCount = [NSString stringWithFormat:@"%d",[model.likeCount intValue]-1];
                            model.isCollect = NO;
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
                            
                            model.isAttention = (following ==1);
                            
                            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                            for (PlazaDataFrame * dataFrame in _dataSource) {
                                
                                PlazaDataModel * data = dataFrame.model;
                                
                                
                                if ([data.user.userID intValue] == [model.user.userID intValue]) {
                                    
                                    //修改状态
                                    data.isAttention = model.isAttention;
                                    
                                    //刷新cell
                                    NSInteger tempIndex = [_dataSource indexOfObject:dataFrame];
                                    NSIndexPath * tempIndexPath = [NSIndexPath indexPathForRow:tempIndex inSection:0];
                                    [_tableView reloadRowsAtIndexPaths:@[tempIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                }
                            }
                            
                            
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
            
            if (model.minImg) {
                
                
                //获取缩略图和正常像素图
                UIImage * thumbImg = [UIImage imageWithURLString:model.minImg];
                UIImage * upImage = [UIImage imageWithURLString:model.coverImg];
                
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                
                
                [shareParams SSDKEnableUseClientShare];
                
                NSString * title = ValidStr(model.oldTitle) ? model.oldTitle : @"看绘本，上绘本宝";
                NSString * content = ValidStr(model.user.nickName) ? model.user.nickName : @"绘本宝热心用户";
                [shareParams SSDKSetupShareParamsByText:content
                                                 images:upImage
                                                    url:[NSURL URLWithString:Urlstr]
                                                  title:title
                                                   type:SSDKContentTypeAuto];
                
                //                [shareParams SSDKSetupSinaWeiboShareParamsByText:model.content title:@"看绘本，上绘本宝" image:upImage url:[NSURL URLWithString:Urlstr] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeImage];
                //定制QQ分享内容
                [shareParams SSDKSetupQQParamsByText:content title:title url:[NSURL URLWithString:Urlstr] audioFlashURL:[NSURL URLWithString:model.galleryBase] videoFlashURL:nil thumbImage:thumbImg image:upImage type:SSDKContentTypeAudio forPlatformSubType:SSDKPlatformSubTypeQQFriend];
                
                //定制QQ空间分享内容
                [shareParams SSDKSetupQQParamsByText:content title:title url:[NSURL URLWithString:Urlstr] audioFlashURL:[NSURL URLWithString:model.galleryBase] videoFlashURL:nil thumbImage:thumbImg image:upImage type:SSDKContentTypeAudio forPlatformSubType:SSDKPlatformSubTypeQZone];
                
                // 定制微信好友的分享内容
                [shareParams SSDKSetupWeChatParamsByText:content
                                                   title:title
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
                [shareParams SSDKSetupWeChatParamsByText:content
                                                   title:title
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
    }
}

#pragma ---mark----CommentControllerDelegate

- (void)reloadPlazaDataWithGalleryID:(NSString *)galleryID tabTag:(NSInteger)tabTag indexPath:(NSIndexPath *)indexPath{
    
    PlazaDataFrame * plazaFrame = [_dataSource objectAtIndex:indexPath.row];
    PlazaDataModel * model = plazaFrame.model;
    int totalNum = [model.commentCount intValue]+1;
    model.commentCount = [NSString stringWithFormat:@"%d",totalNum];
    
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}

#pragma ---mark------登录成功后修改相应状态
- (void)loginSuccessWithNotification:(NSNotification *)info{
    
    NSString * userID = info.object;
    
    [CloudLogin getUserCollectAndAttentionWithUserID:userID success:^(NSDictionary *responseObject) {
        
        int status = [responseObject[@"status"] intValue];
        
        if (status == 0) {
            NSLog(@"---收藏和关注的id号 -- %@",responseObject);
        
            for (PlazaDataFrame * plazaFrame in _dataSource) {
                PlazaDataModel * model = plazaFrame.model;
                
                if (ValidArray(responseObject[@"attentionList"])) {
                    
                    NSArray * attentiontArr = responseObject[@"attentionList"];
                    
                    for (int i = 0; i < attentiontArr.count; i++) {
                        int attentionID = [attentiontArr[i] intValue];
                        
                        if ([model.user.userID intValue] == attentionID) {
                            model.isAttention = YES;
                        }
                    }
                }
                if (ValidArray(responseObject[@"collectionList"])) {
                    NSArray * collectArr = responseObject[@"collectionList"];
                    
                    for (int i = 0; i < collectArr.count; i++) {
                        int galleryID = [collectArr[i] intValue];
                        
                        if ([model.galleryID intValue] == galleryID) {
                            model.isCollect = YES;
                        }
                    }
                }
                
            }
          
            [_tableView reloadData];
            
        }
    } failure:^(NSError *errorMessage) {
        
    }];
    
}


@end
