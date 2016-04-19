//
//  LessonCell.m
//  BabyPlans
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LessonCell.h"

@interface LessonCell ()

//@property (nonatomic,weak) UIView * lineV;


@end
@implementation LessonCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString * reuseID = @"LessonCell";
    
    LessonCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell) {
        cell = [[LessonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setModel:(LessonListModel *)model{

    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.coverImg] placeholderImage:[UIImage imageNamed:@"LessonPlacdehoder"]];
    self.textLabel.text = model.title;
    self.detailTextLabel.text = model.createTime;
}
- (void)layoutSubviews{

    [super layoutSubviews];
    
}
@end
