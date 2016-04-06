//
//  PlazaMainCell.m
//  BabyPlans
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlazaMainCell.h"

@interface PlazaMainCell ()

@property (nonatomic,strong) PlazaDataModel * model;

@property (nonatomic,strong) UIImageView * iconView;
@property (nonatomic,strong) UILabel * nameLbl;
@property (nonatomic,strong) UILabel * dateLbl;
@property (nonatomic,strong) UIImageView * coverImgView;
@property (nonatomic,strong) UILabel * contentLbl;


@end

@implementation PlazaMainCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString * ident = @"PlazaMainCell";
    PlazaMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        cell = [[PlazaMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    return cell;
}
- (void)setModelFrame:(PlazaDataFrame *)modelFrame{

    _modelFrame = modelFrame;
    self.model = modelFrame.model;
}

- (void)createUI{
 
//    self.iconView = [UIImageView]
}

- (void)layoutSubviews{

    
}
@end
