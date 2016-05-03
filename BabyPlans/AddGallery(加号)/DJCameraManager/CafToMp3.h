//
//  CafToMp3.h
//  BabyPlans
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CafToMp3 : NSObject
/**
 *  将caf录音转化成mp3格式
 *
 *  @param cafFilePath caf路径
 *  @param mp3FilePath mp3路径
 */
+ (void)audio_PCMtoMP3:(NSString *)cafFilePath andMP3FilePath:(NSString *)mp3FilePath;
@end
