//
//  MyCollectionViewCell.m
//  MoveCollectionView
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc]init];
        self.imageView.frame = CGRectMake(0, 3, 97, 97);
        [self addSubview:self.imageView];
        
        UIImageView * imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:@"EditImageDel"];
        imageV.frame = CGRectMake(85, 0, 15, 15);
        
        [self addSubview:imageV];
        
    }
    return self;
}







@end
