//
//
//
//
//  Created by even on 15/7/18.
//  Copyright (c) 2015年 Aiden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Music : NSObject
/**
 *  歌曲名字
 */
@property (copy, nonatomic) NSString *name;
/**
 *  歌曲大图
 */
@property (copy, nonatomic) NSString *icon;
/**
 *  歌曲的在音乐库中的url
 */
@property (copy, nonatomic) NSURL *assetURL;
/**
 *  歌手
 */
@property (copy, nonatomic) NSString *singer;
/**
 *  专辑名
 */
@property (copy, nonatomic) NSString *albumTitle;
/**
 *  歌曲图标
 */
@property (copy, nonatomic) UIImage *image;
/**
 *  歌曲长度
 */
@property (nonatomic,assign) NSTimeInterval duration;
@end
