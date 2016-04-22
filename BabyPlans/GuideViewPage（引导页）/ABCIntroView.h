//
//  IntroView.h
//  TCMHealth
//
//  Created by 12344 on 15/10/18.
//  Copyright © 2015年 XDTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABCIntroViewDelegate <NSObject>

-(void)onDoneButtonPressed;

@end

@interface ABCIntroView : UIView
@property id<ABCIntroViewDelegate> delegate;

@end
