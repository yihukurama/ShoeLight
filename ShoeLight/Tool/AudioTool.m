//
//
//
//
//  Created by even on 15/7/18.
//  Copyright (c) 2015年 Aiden. All rights reserved.
//

#import "AudioTool.h"
//#import <AVFoundation/AVFoundation.h>

@implementation AudioTool

+ (void)initialize
{
//    // 1.创建音频会话
//    AVAudioSession *session = [[AVAudioSession alloc] init];
//    
//    // 2.设置会话类型
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    
//    // 3.激活会话
//    [session setActive:YES error:nil];
}

static NSMutableDictionary *_soundIDs;

static NSMutableDictionary *_players;

+ (NSMutableDictionary *)soundIDs
{
    if (!_soundIDs) {
        _soundIDs = [NSMutableDictionary dictionary];
    }
    return _soundIDs;
}
+ (NSMutableDictionary *)players
{
    if (!_players) {
        _players = [NSMutableDictionary dictionary];
    }
    return _players;
}

// 传入需要 播放的音效文件路径
+ (void)playAudioWithURL:(NSURL  *)URL
{
    // 0.判断文件名是否为nil
    if (URL == nil) {
        return;
    }
    NSString *urlStr = [URL absoluteString];
    
    // 1.从字典中取出音效ID
    SystemSoundID soundID = [[self soundIDs][urlStr] unsignedIntValue];
    
    // 判断音效ID是否为nil
    if (!soundID) {
        NSLog(@"创建新的soundID");
        
        
        // 创建音效ID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(URL), &soundID);
        
        // 将音效ID添加到字典中
        [self soundIDs][urlStr] = @(soundID);
    }
    // 播放音效
    AudioServicesPlaySystemSound(soundID);
}

+ (void)disposeAudioWithURL:(NSURL  *)URL
{
    // 0.判断文件名是否为nil
    if (URL == nil) {
        return;
    }
    NSString *urlStr = [URL absoluteString];
    
    // 1.从字典中取出音效ID
    SystemSoundID soundID = [[self soundIDs][urlStr] unsignedIntValue];
    
    if (soundID) {
        // 2.销毁音效ID
        AudioServicesDisposeSystemSoundID(soundID);
        
        // 3.从字典中移除已经销毁的音效ID
        [[self soundIDs] removeObjectForKey:urlStr];
    }
  
}

// 根据音乐文件名称播放音乐
+ (EZAudioPlayer *)playMusicWithURL:(NSURL  *)URL
{
    // 0.判断文件名是否为nil
    if (URL == nil) {
        return nil;
    }
    NSString *urlStr = [URL absoluteString];
    
    // 1.从字典中取出播放器
    EZAudioPlayer *player = [self players][urlStr];
    
    // 2.判断播放器是否为nil
    if (!player) {
        NSLog(@"创建新的播放器");
        
        // 2.3创建播放器
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
//        player.meteringEnabled = YES;

        EZAudioFile *audioFile = [EZAudioFile audioFileWithURL:URL];
        player = [[EZAudioPlayer alloc] initWithAudioFile:audioFile];
//        // 2.4准备播放
//        if(![player prepareToPlay])
//        {
//            return nil;
//        }
        
        // 允许快进
//        player.enableRate = YES;
//        player.rate = 3;
        
        // 2.5将播放器添加到字典中
        [self players][urlStr] = player;
    }
    
    // 3.播放音乐
    if (!player.isPlaying)
    {
        [player play];
    }
   
    return player;
}

// 根据音乐文件名称暂停音乐
+ (void)pauseMusicWithURL:(NSURL  *)URL
{
    // 0.判断文件名是否为nil
    if (URL == nil) {
        return;
    }
    NSString *urlStr = [URL absoluteString];
    
    // 1.从字典中取出播放器
    EZAudioPlayer *player = [self players][urlStr];

    // 2.判断播放器是否存在
    if(player)
    {
        // 2.1判断是否正在播放
        if (player.isPlaying)
        {
            // 暂停
            [player pause];
        }
    }
    
}

// 根据音乐文件名称停止音乐
+ (void)stopMusicWithURL:(NSURL  *)URL;
{
    // 0.判断文件名是否为nil
    if (URL == nil) {
        return;
    }
    NSString *urlStr = [URL absoluteString];
    
    // 1.从字典中取出播放器
    EZAudioPlayer *player = [self players][urlStr];

    // 2.判断播放器是否为nil
    if (player) {
        // 2.1停止播放
        [player pause];
        // 2.2清空播放器
//        player = nil;
        // 2.3从字典中移除播放器
        [[self players] removeObjectForKey:urlStr];
    }
}
@end
