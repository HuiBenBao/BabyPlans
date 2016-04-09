//
//  PlazaMainCell.h
//  BabyPlans
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlazaDataFrame.h"

@class PlazaMainCell;
@protocol PlazaMainCellDelegate <NSObject>

@optional
- (void)getImageArrWithID:(NSString *)galleryID;

- (void)clickBottomBtnIndex:(NSInteger)index galleryID:(NSString *)galleryID;
@end

@interface PlazaMainCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) PlazaDataFrame * modelFrame;


@property (nonatomic,weak) id <PlazaMainCellDelegate>delegate;

@end
