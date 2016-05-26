//
//  SystemMessController.m
//  BabyPlans
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SystemMessController.h"
#import "SystemMessCell.h"

#define CellHeight 50

@interface SystemMessController ()

@property (nonatomic,strong) NSArray * titleArr;


@end


@implementation SystemMessController

- (NSArray *)titleArr{
    
    if (!_titleArr) {
        
        NSMutableArray * tempArr = [NSMutableArray array];
        [CloudLogin SystemMessSuccess:^(NSDictionary *responseObject) {
            
            NSLog(@"%@",responseObject);
            
            int status = [responseObject[@"status"] intValue];
            
            if (status == 0) {
                
                //清空未读消息提醒数字
                UITabBarController * rootVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                
                rootVC.tabBar.items.lastObject.badgeValue = nil;
                
                if (ValidArray(responseObject[@"msgSend"])) {
                    NSArray * dataArr = responseObject[@"msgSend"];
                    
                    for (NSDictionary * dic in dataArr) {
                        NSString * content = [dic valueForKey:@"content"];
                        
                        [tempArr addObject:content];
                    }
                    
                    _titleArr = tempArr;
                    [self.tableView reloadData];

                }else{
                
                    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无相关信息" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                    [alertVC addAction:cancle];
                    
                    [self presentViewController:alertVC animated:YES completion:nil];
                }
                
            }else{
            
                [self.view poptips:responseObject[@"error"]];
            }
            
        } failure:^(NSError *errorMessage) {
           
            [self.view poptips:@"网络异常"];
        }];
    }
    return _titleArr;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"系统消息";
    self.view.backgroundColor = ColorI(0xeeeeee);
    
    [self titleArr];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * content = [_titleArr objectAtIndex:indexPath.row];
    
    CGSize textSize = textSizeFont(content, CellTextFont, KScreenWidth, 0);
    return (ValidStr(content)) ? textSize.height + CellHeight : 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *text = [_titleArr objectAtIndex:indexPath.row];
    
    SystemMessCell * cell = [SystemMessCell valueWithTableView:tableView text:text];
    
    return cell;
}
@end
