//
//  CommentController.m
//  BabyPlans
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CommentController.h"
#import "CommentCell.h"

@interface CommentController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString * galleryID;

@property (nonatomic,strong) NSArray * dataArr;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) UITableView * tableView;


@end

@implementation CommentController

+ (instancetype)commentWithGalleryID:(NSString *)galleryID{

    CommentController * commentVC = [[self alloc] init];
    
    commentVC.galleryID = galleryID;
    commentVC.page = 1;
    
    return commentVC;
}

- (NSArray *)dataArr{

    if (!_dataArr) {
        
        NSMutableArray * dataMuArr = [NSMutableArray array];
        
        [CloudLogin getCommentArrWithGalleryID:_galleryID Page:[NSString stringWithFormat:@"%d",_page] Count:@"20" success:^(NSDictionary *responseObject) {
            
            NSLog(@"%@",responseObject);
            
            int status = [responseObject[@"status"] intValue];
            if (status==0) {
                
                NSArray * dataArr = responseObject[@"comments"];
                for (NSDictionary * dic in dataArr) {
                    
                    CommentFrame * dataFrame = [[CommentFrame alloc] init];
                    dataFrame.model = [CommentModel valueWithDic:dic];
                    [dataMuArr addObject:dataFrame];
                }
                
                _dataArr = dataMuArr;
                [self.tableView reloadData];
                
            }else{
            
                [self.view poptips:responseObject[@"error"]];
            }
            
            
          
        } failure:^(NSError *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataArr];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    self.title = @"评论列表";
    self.view.backgroundColor = ViewBackColor;
}

#pragma -----mark------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return (_dataArr) ? _dataArr.count : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentFrame * dataFrame = [_dataArr objectAtIndex:indexPath.row];
    return dataFrame.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentCell * cell = [CommentCell cellWithTableView:tableView indexPath:indexPath];
    
    CommentFrame * dataFrame = [_dataArr objectAtIndex:indexPath.row];
    
    cell.dataFrame = dataFrame;
    
    return cell;
}
@end
