//
//  SystemMessCell.h
//  BabyPlans
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CellTextFont FONT_ADAPTED_NUM(15)

@interface SystemMessCell : UITableViewCell


+ (instancetype)valueWithTableView:(UITableView *)tableView text:(NSString *)text;

@end
