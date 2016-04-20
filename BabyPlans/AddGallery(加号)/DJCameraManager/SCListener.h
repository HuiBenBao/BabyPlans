//
//  SCListener.h
//  BabyPlans
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioServices.h>

@interface SCListener : NSObject{
    AudioQueueLevelMeterState *levels;
    
    AudioQueueRef queue;
    AudioStreamBasicDescription format;
    Float64 sampleRate;
}

+ (SCListener *)sharedListener;

- (void)listen;
- (BOOL)isListening;
- (void)pause;
- (void)stop;

- (Float32)averagePower;
- (Float32)peakPower;
- (AudioQueueLevelMeterState *)levels;


@end
