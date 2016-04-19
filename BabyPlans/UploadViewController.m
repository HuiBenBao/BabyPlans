//
//  UploadViewController.m
//  baby
//
//  Created by zhang da on 14-3-9.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UploadViewController.h"
#import "NewGalleryViewController.h"
#import "NewPictureViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self createUI];
}

- (void)createUI {
    
    self.title = @"绘本宝";
    self.view.backgroundColor = Color(255, 253, 234);
    
    CGFloat btnW = 80;
    
    float posY = (KScreenHeight - 20 - 180)/2;
    UIButton *multiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    multiBtn.frame = CGRectMake((KScreenWidth-btnW)/2, posY, btnW, btnW);
    multiBtn.layer.cornerRadius = 40;
    multiBtn.layer.borderColor = [UIColor colorWithRed:242/255.0 green:101/255.0 blue:34/255.0 alpha:1].CGColor;
    multiBtn.layer.borderWidth = 2;
    multiBtn.backgroundColor = [UIColor whiteColor];
    [multiBtn setTitleColor:[UIColor colorWithRed:242/255.0 green:101/255.0 blue:34/255.0 alpha:1] forState:UIControlStateNormal];
    [multiBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [multiBtn setTitle:@"原创绘本" forState:UIControlStateNormal];
    multiBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [multiBtn addTarget:self action:@selector(newMultiPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:multiBtn];
    
    
    posY += 80;
    posY += 20;
    UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    singleBtn.frame = CGRectMake((KScreenWidth-btnW)/2, posY, 80, 80);
    singleBtn.layer.cornerRadius = 40;
    singleBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:101/255.0 blue:34/255.0 alpha:1];
    [singleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [singleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [singleBtn setTitle:@"经典绘本" forState:UIControlStateNormal];
    singleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [singleBtn addTarget:self action:@selector(newSinglePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:singleBtn];
}


#pragma mark uievent

- (void)newSinglePicture {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"0"] forKey:@"glSegementIndex"];
        NewGalleryViewController *ngVC = [[NewGalleryViewController alloc] init];
    
//        ngVC.maxPictureCount = 30;
//
//        [self.navigationController pushViewController:ngVC animation:ViewSwitchAnimationNone finished:^{
//        
//        NewPictureViewController *picCtr = [[NewPictureViewController alloc] initWithRoot:ngVC];
//
//        [self.navigationController pushViewController:picCtr animated:YES];
//    }];
    
}

- (void)newMultiPicture {
     [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"1"] forKey:@"glSegementIndex"];
    NewGalleryViewController *ngVC = [[NewGalleryViewController alloc] init];
//    ngVC.maxPictureCount = 30;

    [self.navigationController pushViewController:ngVC animated:YES];
    
}


@end
