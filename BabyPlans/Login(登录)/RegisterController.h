//
//  RegisterController.h
//  BabyPlans
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RegisterControllerDelegate <NSObject>
@required
- (void)getInfoPhoneNum:(NSString *)phonenum passWord:(NSString *)password;

@end

@interface RegisterController : UIViewController

@property (nonatomic,weak) id <RegisterControllerDelegate>delegate;

@end
