//
//  CollectCell.h
//  BabyPlans
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectFrame.h"

@class CollectCell;
@protocol CollectCellDelegate <NSObject>

@optional
- (void)getImageArrWithID:(NSString *)galleryID;

@end

@interface CollectCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) CollectFrame * modelFrame;

@property (nonatomic,weak) id <CollectCellDelegate>delegate;
@end
