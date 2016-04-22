//
//  TCMSuggestionBtn.m
//  TCMHealth
//
//  Created by 12344 on 16/1/9.
//  Copyright © 2016年 XDTC. All rights reserved.
//

#import "TCMSuggestionBtn.h"

#define BTNWIDTH KScreenWidth/4

@implementation TCMSuggestionBtn

- (UIImageView *)imgV{

    if (!_imgV) {
        _imgV = [[UIImageView alloc] init];
        
        CGFloat imgW = 152*SCREEN_WIDTH_RATIO55/3;
        CGFloat imgH = imgW;
        CGFloat imgX = (BTNWIDTH - imgW)/2;
        CGFloat imgY = 0;
        
        _imgV.frame = CGRectMake(imgX, imgY, imgW, imgH);
    }
    
    return _imgV;
}

- (UILabel *)mainLbl{

    if (!_mainLbl) {
        _mainLbl = [[UILabel alloc] init];
        
        CGFloat lblW = BTNWIDTH;
        CGFloat lblY = CGRectGetMaxY(self.imgV.frame) + 45*SCREEN_WIDTH_RATIO55/3;
        CGFloat lblX = 0;
        CGFloat lblH = 45*SCREEN_WIDTH_RATIO55/3;
        
        _mainLbl.font = FONT_ADAPTED_WIDTH(40/3);
        _mainLbl.textColor = ColorI(0x666666);
        _mainLbl.textAlignment = NSTextAlignmentCenter;
        _mainLbl.frame = CGRectMake(lblX, lblY, lblW, lblH);
    }
    
    return _mainLbl;
}

- (UILabel *)detailLbl{

    if (!_detailLbl) {
        _detailLbl = [[UILabel alloc] init];
        
        CGFloat lblW = BTNWIDTH;
        CGFloat lblY = CGRectGetMaxY(self.mainLbl.frame) + 25*SCREEN_WIDTH_RATIO55/3;
        CGFloat lblX = 0;
        CGFloat lblH = 45*SCREEN_WIDTH_RATIO55/3;
        
        _detailLbl.font = FONT_ADAPTED_WIDTH(40/3);
        _detailLbl.textColor = ColorI(0x666666);
        _detailLbl.textAlignment = NSTextAlignmentCenter;
        _detailLbl.frame = CGRectMake(lblX, lblY, lblW, lblH);

    }
    
    return _detailLbl;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType{

    
    
    TCMSuggestionBtn * btn = [super buttonWithType:buttonType];
    
    [btn addSubview:btn.imgV];
    [btn addSubview:btn.mainLbl];
    [btn addSubview:btn.detailLbl];
    
    return btn;
}
@end
