//
//  UIImage+Strech.h
//  DayOne
//
//  Created by Mac on 14-4-17.
//  Copyright (c) 2014年 Yuandong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Strech)

// 把大于size的图片压缩到size大小 
+ (UIImage *)compressImage:(UIImage *)img toSize:(CGSize)size;

// 把大于500*500图片压至500*500
+ (UIImage *)compressImage:(UIImage *)img;

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

// 根据源图截取一个正方形，并缩放
+ (UIImage *)cutSquareImage:(UIImage *)image byScale:(CGFloat)scale;

// 对源图进行缩放
+ (UIImage *)cutImage:(UIImage *)image byScale:(CGFloat)scale;

// 通过文件名找到所在路径，根据路径把照片加载入data,以数据的方式获取img,节省内存
+ (UIImage *)imageFromDataNamed:(NSString *)imgName;

// 生成一张纯色图片
- (UIImage *)initWithSize:(CGSize)size color:(UIColor *)color;

// 返回image的字节数
- (NSUInteger)kilobyte;

// 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName;
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;


@end
