//
//
//
//
//  Created by even on 15/7/18.
//  Copyright (c) 2015年 Aiden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Music.h"
// 每秒对音频的采样次数
#define kSamplePerSecond 100

@interface MusicsTool : NSObject
// 获取所有音乐
+ (NSArray *)musics;

// 更新所有音乐
+ (void)updateMusics;

// 设置当前正在播放的音乐
+ (void)setPlayingMusic:(Music *)music;

// 返回当前正在播放的音乐
+ (Music *)playingMusic;

// 获取下一首
+ (Music *)nextMusic;

// 获取上一首
+ (Music *)previousMusic;

+ (NSDictionary *)playingMusicWaveformDict;

@end
