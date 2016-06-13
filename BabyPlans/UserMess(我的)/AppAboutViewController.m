//
//  AppAboutViewController.m
//  BabyPlans
//
//  Created by 宝贝计画 on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppAboutViewController.h"
#import "AppSynopsisViewController.h"
static const CGFloat CellHeight = 40.0;

#define HeaderHeight 140*SCREEN_WIDTH_RATIO55

@interface AppAboutViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, weak) UIWebView * webView;


@end

@implementation AppAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self headerView];
    self.title = @"关于";

}


- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.backgroundColor = ColorI(0xdddddd);
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.scrollEnabled =NO;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
}


- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView =[[UIView alloc]initWithFrame: CGRectMake(0, 0, KScreenWidth, HeaderHeight)];
        _headerView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100*SCREEN_WIDTH_RATIO55, 100*SCREEN_WIDTH_RATIO55)];
        imgView.image =  [UIImage imageNamed:@"appLogo.png"];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom, KScreenWidth,_headerView.height-imgView.bottom)];
        label.font = FontBold(14);
        NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *str = [NSString stringWithFormat:@"绘本宝 %@", version];
        label.text = str;
        label.textAlignment = NSTextAlignmentCenter;
        

        CGPoint center = _headerView.center;
        center.y = center.y-label.height/2;
        imgView.center = center;

        [_headerView addSubview:imgView];
        [_headerView addSubview:label];
    
    }
    return _headerView;
}

#pragma mark ===============UITableViewDataSource===============


//设置每个组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //风采展示
    static NSString *cellIndentifier = @"firstCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell buildBgView:ColorI(0xdddddd) frame:CGRectMake(0, CellHeight-1, KScreenWidth, 1)];

    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"去评分";
            
            break;
        case 1:
            cell.textLabel.text = @"简介";

            break;

        default:
            break;
    }
    
    
    return cell;
    
}

#pragma mark =============== UITableViewDelegate代理方法===============
//设置每行Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1061521366"]];
    }else{
        [self.navigationController pushViewController: [[AppSynopsisViewController alloc]init] animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HeaderHeight;
   
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headerView;
}



@end
