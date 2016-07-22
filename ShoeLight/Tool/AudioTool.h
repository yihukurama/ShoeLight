//
//
//
//
//  Created by even on 15/7/18.
//  Copyright (c) 2015年 Aiden. All rights reserved.
//
#import <Foundation/Foundation.h>
//#import <AVFoundation/AVFoundation.h>
#import "EZAudio.h"

@interface AudioTool : NSObject


// 播放音效
// 传入需要 播放的音效文件路径
+ (void)playAudioWithURL:(NSURL *)URL;

// 销毁音效
+ (void)disposeAudioWithURL:(NSURL *)URL;

// 根据音乐文件路径播放音乐
+ (EZAudioPlayer *)playMusicWithURL:(NSURL *)URL;

// 根据音乐文件路径暂停音乐
+ (void)pauseMusicWithURL:(NSURL *)URL;

// 根据音乐文件路径停止音乐
+ (void)stopMusicWithURL:(NSURL *)URL;
@end
