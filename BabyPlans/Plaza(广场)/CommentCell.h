//
//  CommentCell.h
//  BabyPlans
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentFrame.h"

@protocol CommentCellDelegate <NSObject>

@optional
- (void)playVoiceWithModel:(CommentModel *)model;

@end

@interface CommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) CommentFrame * dataFrame;

@property (nonatomic,weak) id <CommentCellDelegate>delegate;

@end
