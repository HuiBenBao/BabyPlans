//
//  PlazaTopView.m
//  BabyPlans
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlazaTopView.h"
#define tableHeaderHeight (45*SCREEN_WIDTH_RATIO55)


@interface PlazaTopView ()

@property (nonatomic,strong) NSArray * btnArr;


@end
@implementation PlazaTopView



- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self createBtn];
        
    }
    return self;
}
/**
 *  按钮视图
 */
- (void)createBtn{

    CGFloat btnBackX = 15*SCREEN_WIDTH_RATIO55;
    CGFloat btnBackW = KScreenWidth -btnBackX*2;
    CGFloat btnBackY = 5*SCREEN_WIDTH_RATIO55;
    CGFloat btnBackH = tableHeaderHeight - btnBackY*2;
    
    UIView * BtnView = [[UIView alloc] initWithFrame:CGRectMake(btnBackX, btnBackY, btnBackW, btnBackH)];
    
    BtnView.layer.cornerRadius = 8*SCREEN_WIDTH_RATIO55;
    BtnView.clipsToBounds = YES;
    BtnView.layer.borderWidth = 1;
    BtnView.layer.borderColor = [UIColor orangeColor].CGColor;
    
    NSArray * titleArr = @[@"经典绘本/故事直播",@"原创绘本/故事直播"];
    NSMutableArray * btnArr = [NSMutableArray array];
    
    for (int i = 0; i < titleArr.count ; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat btnX = (btnBackW/2)*i;
        CGFloat btnW =  btnBackW/2;
        btn.frame = CGRectMake(btnX, 0, btnW, btnBackH);
        
        btn.titleLabel.font = FONT_ADAPTED_NUM(14);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor] ImgSize:CGRectMake(0, 0, btnW, btnBackH)] forState:UIControlStateSelected];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [BtnView addSubview:btn];
        
        if (i == 0) {
            [self btnClick:btn];
        }
        
        [btnArr addObject:btn];
    }
    
    self.btnArr = btnArr;
    [self addSubview:BtnView];
}
- (void)btnClick:(UIButton *)sender{

    sender.selected = YES;
    
    for (UIButton * btn in self.btnArr) {
        if (btn.tag != sender.tag) {
            UIButton * otherBtn = (UIButton *)btn;
            otherBtn.selected = !sender.selected;
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollToIndex:)]) {
        [self.delegate scrollToIndex:sender.tag];
    }
}

- (void)selectAtIndex:(NSInteger)index{

    UIButton * currentBtn;
    
    for (UIButton *btn in self.btnArr) {
        
        if (btn.selected) {
            currentBtn = btn;
        }
    }
    
    for (UIButton * btn in self.btnArr) {
        
        if (btn.tag == index) {
            btn.selected = YES;
        }else{
        
            btn.selected = NO;
        }
    }
}
@end
