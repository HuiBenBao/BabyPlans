//
//  UserDetailController.h
//  BabyPlans
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMessModel.h"

@interface UserDetailController : UITableViewController

+ (instancetype)userDetailWithModel:(UserMessModel *)model;

@end
