//
//  UserDetailController.h
//  BabyPlans
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMessModel.h"

@protocol UserDetailControllerDelegate <NSObject>

@optional
- (void)updateUserMess;

@end

@interface UserDetailController : UITableViewController

+ (instancetype)userDetailWithModel:(UserMessModel *)model;

@property (nonatomic,weak) id <UserDetailControllerDelegate>delegate;

@end
