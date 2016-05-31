//
//  TCMTitleScrollView.m
//  TCMHealth
//
//  Created by xdtc on 15/8/19.
//  Copyright (c) 2015年 XDTC. All rights reserved.
//

#import "FWBTitleScrollView.h"


@interface FWBTitleScrollView()
@property (nonatomic,strong)UIView *lastView;


@end
@implementation FWBTitleScrollView

#define BTN_WIDTH ((KScreenWidth - 1)/3)                        //其他按钮的宽度
#define SCROLL_VIEW_HEIGHT ((87.0 / 2) * SCREEN_HEIGHT_RATTO4)  //滚动条的高度，即所有标题所在的view的高度
#define BTN_HIGHT ((87.0 / 2 - 3) * SCREEN_HEIGHT_RATTO4)       //43.5点是按钮的高度，留3个点的高度放下划线


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 按钮个数
        NSArray * titleArr = @[@"已发布",@"未通过",@"审核中"];
        
        NSMutableArray * tempArr = [NSMutableArray array];
        for (int index = 0; index < titleArr.count; index++) {
            UIButton *btn = [[UIButton alloc]init];
            [btn setTitleColor:ColorI(0x6b6b6b) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            btn.titleLabel.font = FONT_ADAPTED_NUM(16);
            [btn setTitle:titleArr[index] forState:UIControlStateNormal];
            // 设置按钮的frame

            btn.frame = CGRectMake(CGRectGetMaxX(self.lastView.frame) + 0.01, 0, BTN_WIDTH, self.height);
            
            btn.tag = index;
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            self.lastView = btn;
            
            // 添加分隔线
            UIView *line = [[UIView alloc]init];
            CGFloat lineH = 15.0 *SCREEN_WIDTH_RATIO55;
            CGFloat lineW = 0.5;
            CGFloat lineX = CGRectGetMaxX(self.lastView.frame);
            CGFloat lineY = btn.center.y - (lineH * 0.5);
            line.frame = CGRectMake(lineX, lineY, lineW, lineH);
            line.backgroundColor = ColorI(0x8b8b8b);
            self.lastView = line;
            [self addSubview:line];
            
            [self addSubview:btn];
            
            [tempArr addObject:btn];
            
            if (index==0) {
                [self btnClick:btn];
            }
        }
        _btnArr = tempArr;
        
        // 添加标题下面的滚动条
        UIView *scrollBar = [[UIView alloc]init];
        scrollBar.backgroundColor = ColorI(0x179bc2);
        UIButton *firstBtn = self.btnArr[0];
        CGFloat scrollBarX = firstBtn.titleLabel.frame.origin.x;
        CGFloat scrollBarH = 3 * SCREEN_WIDTH_RATIO55;
        CGFloat scrollBarY = frame.size.height - scrollBarH - 1;
        CGFloat scrollBarW = firstBtn.titleLabel.frame.size.width;

        scrollBar.frame = CGRectMake(scrollBarX, scrollBarY, scrollBarW, scrollBarH);
        
        [self addSubview:scrollBar];
        self.scrollBar = scrollBar;
        
        [self buildBgView:ColorI(0xdddddd) frame:CGRectMake(0, scrollBar.bottom, self.width, 1)];
    }
    return self;
}
- (void)setCurrentSelect:(NSInteger)currentSelect{

    _currentSelect = currentSelect;

    UIButton * btn = _btnArr[_currentSelect];
    [self btnClick:btn];
}
- (void)btnClick:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(clickTitleButton:)]) {
        [self.delegate clickTitleButton:sender];
    }
}

@end
