//
//  AddPicScrollView.h
//  BabyPlans
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define margic 20*SCREEN_WIDTH_RATIO55
static const int ImgNumOnOneline = 4; //每行显示图片数量
#define imageRadius (KScreenWidth - (ImgNumOnOneline + 1)*margic)/ImgNumOnOneline //图片半径

@protocol AddPicScrollViewDelegate <NSObject>

@optional
- (void)addPictureBtnClick;

@end

@interface AddPicScrollView : UIScrollView

- (void)addPicture:(UIImage *)img imgID:(NSString *)imgID;

- (void)removeImageViewWithTag:(NSInteger)tag;

@property (nonatomic,weak) id <AddPicScrollViewDelegate>picDelegate;
@property (nonatomic,strong) NSMutableArray * imageViewArr;

@end
