//
//  LessonCell.h
//  BabyPlans
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonListModel.h"

@interface LessonCell : UITableViewCell

@property (nonatomic,strong) LessonListModel * model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
