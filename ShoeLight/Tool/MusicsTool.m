//
//
//
//
//  Created by even on 15/7/18.
//  Copyright (c) 2015年 Aiden. All rights reserved.
//



#import "MusicsTool.h"
#import "MJExtension.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CommonTool.h"
#import <AVFoundation/AVFoundation.h>

#define absX(x) (x < 0 ? 0 - x : x)
#define minMaxX(x, mn, mx) (x <= mn ? mn : (x >= mx ? mx : x))
#define noiseFloor (-50.0)
#define decibel(amplitude) (20.0 * log10(absX(amplitude) / 32767.0))




@implementation MusicsTool

// 所有歌曲
static NSArray *_musics;

// 当前正在播放歌曲
static Music *_playingMusic;

static NSDictionary *_playingMusicWaveformDict;

// 获取所有音乐
+ (NSArray *)musics
{
    if (!_musics) {
        [self updateMusics];
    }
    return _musics;
}


// 更新所有音乐
+ (void)updateMusics {
    MPMediaQuery *mediaQueue = [MPMediaQuery songsQuery];
    NSMutableArray *tmpArr = [NSMutableArray array];
    
    for (MPMediaItem *item in mediaQueue.items) {
        Music *music = [[Music alloc]init];
        music.name = item.title;
        music.singer = item.artist;
        music.albumTitle = item.albumTitle;
        music.assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
        music.duration = item.playbackDuration;
        music.image =  [item.artwork imageWithSize: CGSizeMake(200, 200)];
        
        [tmpArr addObject:music];
    }
    _musics = tmpArr;
}

+ (NSDictionary *)playingMusicWaveformDict {
    return _playingMusicWaveformDict;
}

// 设置当前正在播放的音乐
+ (void)setPlayingMusic:(Music *)music
{
    // 判断传入的音乐模型是否为nil
    // 判断数组中是否包含该音乐模型
    if (!music ||
        ![[self musics] containsObject:music]) {
        return;
    }
    _playingMusic = music;
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        _playingMusicWaveformDict = [self analyseWaveformOfMusic:music];
//    });
}

// 返回当前正在播放的音乐
+ (Music *)playingMusic
{
    return _playingMusic;
}

// 获取下一首
+ (Music *)nextMusic
{
    // 1.获取当前播放的索引
    NSUInteger currentIndex = [[self musics] indexOfObject:_playingMusic];
    // 2.计算下一首的索引
    NSInteger nextIndex = currentIndex + 1;
    // 3.越界处理
    if (nextIndex >= [[self musics] count]) {
        nextIndex = 0;
    }
    // 4.取出下一首的模型返回
    return [self musics][nextIndex];
}

// 获取上一首
+ (Music *)previousMusic
{
    // 1.获取当前播放的索引
    NSUInteger currentIndex = [[self musics] indexOfObject:_playingMusic];
    // 2.计算上一首的索引
    NSInteger perviouesIndex = currentIndex - 1;
    // 3.越界处理
    if (perviouesIndex < 0) {
        perviouesIndex = [[self musics] count] - 1;
    }
    // 4.取出下一首的模型返回
    return [self musics][perviouesIndex];
}



+ (NSDictionary *)analyseWaveformOfMusic:(Music *)music
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:music.assetURL options:nil];
    if (asset == nil) {
        return nil;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    CGFloat widthInPixels = music.duration * kSamplePerSecond;
    CGFloat heightInPixels = 320;
    
    NSError *error = nil;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    
    NSArray *audioTrackArray = [asset tracksWithMediaType:AVMediaTypeAudio];
    
    if (audioTrackArray.count == 0) {
        return nil;
    }
    
    AVAssetTrack *songTrack = [audioTrackArray objectAtIndex:0];
    
    NSDictionary *outputSettingsDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                        [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                        [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                        [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                        [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                        nil];
    AVAssetReaderTrackOutput *output = [[AVAssetReaderTrackOutput alloc] initWithTrack:songTrack outputSettings:outputSettingsDict];
    [reader addOutput:output];
    
    UInt32 channelCount;
    NSArray *formatDesc = songTrack.formatDescriptions;
    for (unsigned int i = 0; i < [formatDesc count]; ++i) {
        CMAudioFormatDescriptionRef item = (__bridge CMAudioFormatDescriptionRef)[formatDesc objectAtIndex:i];
        const AudioStreamBasicDescription* fmtDesc = CMAudioFormatDescriptionGetStreamBasicDescription(item);
        
        if (fmtDesc == nil) {
            return nil;
        }
        
        channelCount = fmtDesc->mChannelsPerFrame;
    }
    
    
    UInt32 bytesPerInputSample = 2 * channelCount;
    unsigned long int totalSamples = (unsigned long int)asset.duration.value;
    NSUInteger samplesPerPixel = totalSamples / (widthInPixels);
    samplesPerPixel = samplesPerPixel < 1 ? 1 : samplesPerPixel;
    [reader startReading];
    
    float halfGraphHeight = (heightInPixels / 2);
    double bigSample = 0;
    NSUInteger bigSampleCount = 0;
    NSMutableData * data = [NSMutableData dataWithLength:32768];
    
    CGFloat currentX = 0;
    while (reader.status == AVAssetReaderStatusReading) {
        CMSampleBufferRef sampleBufferRef = [output copyNextSampleBuffer];
        
        if (sampleBufferRef) {
            CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBufferRef);
            size_t bufferLength = CMBlockBufferGetDataLength(blockBufferRef);
            
            if (data.length < bufferLength) {
                [data setLength:bufferLength];
            }
            
            CMBlockBufferCopyDataBytes(blockBufferRef, 0, bufferLength, data.mutableBytes);
            
            SInt16 *samples = (SInt16 *)data.mutableBytes;
            int sampleCount = (int)(bufferLength / bytesPerInputSample);
            for (int i = 0; i < sampleCount; i++) {
                Float32 sample = (Float32) *samples++;
                sample = decibel(sample);
                sample = minMaxX(sample, noiseFloor, 0);
                
                for (int j = 1; j < channelCount; j++)
                    samples++;
                
                bigSample += sample;
                bigSampleCount++;
                
                if (bigSampleCount == samplesPerPixel) {
                    double averageSample = bigSample / (double)bigSampleCount;
                    
                    float pixelHeight = halfGraphHeight * (1 - sample / noiseFloor);
                    if (pixelHeight < 0) {
                        pixelHeight = 0;
                    }
                    NSString *xKey = [NSString stringWithFormat:@"%@",@(currentX)];
                    [dict setValue:@(pixelHeight) forKey:xKey];
                    
                    
                    currentX ++;
                    bigSample = 0;
                    bigSampleCount  = 0;
                }
            }
            CMSampleBufferInvalidate(sampleBufferRef);
            CFRelease(sampleBufferRef);
        }
    }
    
    return dict;
    
}

@end
