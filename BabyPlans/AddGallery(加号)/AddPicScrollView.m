//
//  AddPicScrollView.m
//  BabyPlans
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AddPicScrollView.h"


@interface AddPicScrollView ()

@property (nonatomic,strong) UIImageView * addImgView;


@end

@implementation AddPicScrollView


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
     
        self.addImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addpic_btn.png"]];
        
        CGFloat imgW = imageRadius;
        CGFloat imgH = imgW;
        CGFloat imgY = (frame.size.height - imgH)/2;
        

        _addImgView.frame = CGRectMake(margic, imgY, imgW, imgH);
        [self.addImgView addTarget:self action:@selector(addPicture)];
        
        
        [self addSubview:_addImgView];
        
        if (_imageViewArr==nil) {
            _imageViewArr = [NSMutableArray array];

        }
    }
    
    return self;
}
- (void)addPicture:(UIImage *)img imgID:(NSString *)imgID{

    UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
    
    imgView.tag = [imgID intValue];
    
    [self addSubview:imgView];
    [_imageViewArr addObject:imgView];
    
}

- (void)removeImageViewWithTag:(NSInteger)tag{
    
    for (UIImageView * imgV in _imageViewArr) {
        if (imgV.tag == tag) {
            [imgV removeFromSuperview];
        }
    }
}
- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat maxX = margic;
    CGFloat maxY = margic;
    for (int i = 0; i < _imageViewArr.count; i++) {
        UIImageView * imageView = [_imageViewArr objectAtIndex:i];
       
        CGRect imgF = self.addImgView.frame;
        
        imgF.origin.x = margic + (self.addImgView.width+margic)*(i%ImgNumOnOneline);
        imgF.origin.y = margic + (self.addImgView.width+margic)*(i/ImgNumOnOneline);
        
        imageView.frame = imgF;
       
        maxX = CGRectGetMaxX(imgF) + margic;
        maxY = CGRectGetMaxY(imgF) + margic;
    }
    
    CGRect addF = _addImgView.frame;
    NSInteger index = _imageViewArr.count;
    addF.origin.x = margic + (self.addImgView.width+margic)*(index%ImgNumOnOneline);
    addF.origin.y = margic + (self.addImgView.width+margic)*(index/ImgNumOnOneline);
    
    self.addImgView.frame = addF;
    self.addImgView.image = [UIImage imageNamed:@"addpic_btn.png"];
    
    self.contentSize = CGSizeMake(CGRectGetMaxX(_addImgView.frame)+margic, CGRectGetMaxY(_addImgView.frame)+margic);
    
}

- (void)addPicture{

    if ([self.picDelegate respondsToSelector:@selector(addPictureBtnClick)]) {
        [self.picDelegate addPictureBtnClick];
    }
}
@end
