//
//  IntroView.m
//  TCMHealth
//
//  Created by 12344 on 15/10/18.
//  Copyright © 2015年 XDTC. All rights reserved.
//

#import "ABCIntroView.h"

@interface ABCIntroView () <UIScrollViewDelegate>
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIPageControl *pageControl;
@property (strong, nonatomic) UIView *holeView;
@property (strong, nonatomic) UIView *circleView;
@property (strong, nonatomic) UIButton *doneButton;

@end

@implementation ABCIntroView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = ViewBackColor;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, KScreenHeight - 180/3 *SCREEN_WIDTH_RATIO55, self.frame.size.width, 10*SCREEN_WIDTH_RATIO55)];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:self.pageControl];
        
        [self createViewOne];
        [self createViewTwo];
        [self createViewThree];
        [self createViewFour];
        
        self.pageControl.numberOfPages = 4;
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width*4, self.scrollView.frame.size.height);
        
        //This is the starting point of the ScrollView
        CGPoint scrollPoint = CGPointMake(0, 0);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    return self;
}

- (void)onFinishedIntroButtonPressed:(id)sender {
    [self.delegate onDoneButtonPressed];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
    
    if (self.pageControl.currentPage==3) {
        self.pageControl.hidden = YES;
    }else{
    
        self.pageControl.hidden = NO;
    }
    
}


-(void)createViewOne{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
//    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.image = [UIImage imageNamed:@"GuidePageImg1.jpg"];
    [view addSubview:imageview];
    
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
}


-(void)createViewTwo{
    
    CGFloat originWidth = self.frame.size.width;
    CGFloat originHeight = self.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originWidth, 0, originWidth, originHeight)];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.frame];
//    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.image = [UIImage imageNamed:@"GuidePageImg2.jpg"];
    [view addSubview:imageview];
    
    
    self.scrollView.delegate = self;
    
    [self.scrollView addSubview:view];
    

    
}
-(void)createViewThree{
    
    CGFloat originWidth = self.frame.size.width;
    CGFloat originHeight = self.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(originWidth*2, 0, originWidth, originHeight)];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.frame];
    //    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.image = [UIImage imageNamed:@"GuidePageImg3.jpg"];
    [view addSubview:imageview];
    
    
    self.scrollView.delegate = self;
    
    [self.scrollView addSubview:view];
    
    
}
-(void)createViewFour{
    
    
    CGFloat originHeight = self.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth*3, 0, KScreenWidth, originHeight)];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.frame];
    //    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.image = [UIImage imageNamed:@"GuidePageImg4.jpg"];
    [view addSubview:imageview];
    
    
    self.scrollView.delegate = self;
    
    [self.scrollView addSubview:view];
    
    [self createBtnOnView:view];
    
}

- (void)createBtnOnView:(UIView *)view{
    
    //Done Button
    
    CGFloat btnW = 600*SCREEN_WIDTH_RATIO55/3;
    CGFloat btnX = (KScreenWidth-btnW)/2;
    CGFloat btnH = 147*SCREEN_WIDTH_RATIO55/3;
    CGFloat btnY = KScreenHeight - 20 *SCREEN_WIDTH_RATIO55 - btnH;
    
    self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [self.doneButton setTitle:@"立 即 体 验" forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = FONTBOLD_ADAPTED_WIDTH(60/3);
    self.doneButton.backgroundColor = [UIColor clearColor];

    
    self.doneButton.layer.cornerRadius = 4;
    self.doneButton.layer.borderWidth = 1;
    self.doneButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.doneButton addTarget:self action:@selector(onFinishedIntroButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:self.doneButton];
    
}

@end