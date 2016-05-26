//
//  UserGalleryCell.h
//  BabyPlans
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlazaDataModel.h"

@interface UserGalleryCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) PlazaDataModel * model;
@end
