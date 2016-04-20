//
//  AddPicScrollView.m
//  BabyPlans
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AddPicScrollView.h"
#define margic 20*SCREEN_WIDTH_RATIO55

@interface AddPicScrollView ()

@property (nonatomic,strong) UIImageView * addImgView;
@property (nonatomic,strong) NSMutableArray * imageViewArr;


@end

@implementation AddPicScrollView


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
     
        self.addImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addpic_btn.png"]];
        
        CGFloat imgY = 10*SCREEN_WIDTH_RATIO55;
        CGFloat imgH = frame.size.height - imgY*2;
        CGFloat imgW = imgH;
        

        _addImgView.frame = CGRectMake(margic, imgY, imgW, imgH);
        [self.addImgView addTarget:self action:@selector(addPicture)];
        
        
        [self addSubview:_addImgView];
        
        self.imageViewArr = [NSMutableArray array];
    }
    
    return self;
}
- (void)addPicture:(UIImage *)img voice:(NSString *)voice{

    UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
    
    [self addSubview:imgView];
    [self.imageViewArr insertObject:imgView atIndex:0];
    
}
- (void)layoutSubviews{

    [super layoutSubviews];
    
    
    CGFloat maxW = margic;
    for (int i = 0; i < _imageViewArr.count; i++) {
        UIImageView * imageView = [_imageViewArr objectAtIndex:i];
       
        CGRect imgF = self.addImgView.frame;
        
        imgF.origin.x = margic + (self.addImgView.width+margic)*i;
        
        imageView.frame = imgF;
       
        maxW = CGRectGetMaxX(imgF) + margic;
    }
    
    CGRect addF = _addImgView.frame;
    addF.origin.x = maxW;
    self.addImgView.frame = addF;
    
    self.contentSize = CGSizeMake(CGRectGetMaxX(_addImgView.frame)+margic, 0);
    
}

- (void)addPicture{

    if ([self.picDelegate respondsToSelector:@selector(addPictureBtnClick)]) {
        [self.picDelegate addPictureBtnClick];
    }
}
@end
