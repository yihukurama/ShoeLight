//
//  UIImage+Strech.m
//  DayOne
//
//  Created by Mac on 14-4-17.
//  Copyright (c) 2014年 Yuandong. All rights reserved.
//

#import "UIImage+Strech.h"

@implementation UIImage (Strech)

+(UIImage *)strechableImageWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *strechableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.5, image.size.width * 0.5, image.size.height * 0.5, image.size.width * 0.5)];
    
    //[image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    return strechableImage;
}


// 根据源图截取一个正方形，并缩放
+(UIImage *)cutSquareImage:(UIImage *)image byScale:(CGFloat)scale
{
    // 以图片宽高中较小值作为截图的宽高
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    CGSize size = imageView.frame.size;
    CGFloat cutWidth = size.width >= size.height ? size.height : size.width;
    CGFloat cutHeight = cutWidth;
    CGSize cutSize = CGSizeMake(cutWidth, cutHeight);
    
    // 开启context
    if (UIGraphicsBeginImageContextWithOptions!= nil) {
        UIGraphicsBeginImageContextWithOptions(cutSize, YES, scale);
    } else {
        UIGraphicsBeginImageContext(cutSize);
    }
    
    // 平移context
    CGFloat offsetX,offsetY;
    if (size.width >= size.height) {
        offsetX = -(size.width - size.height) * 0.5;
    } else {
        offsetY = -(size.height - size.width) * 0.5;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, offsetX, offsetY);
    
    // 获取截图
    [imageView.layer renderInContext:ctx];
    UIImage *cutImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭context
    UIGraphicsEndImageContext();
    return cutImage;
}


// 对源图进行缩放
+(UIImage *)cutImage:(UIImage *)image byScale:(CGFloat)scale
{
    // 以图片宽高作为截图的宽高
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    CGSize cutSize = imageView.frame.size;

    // 开启context
    if (UIGraphicsBeginImageContextWithOptions!= nil) {
        UIGraphicsBeginImageContextWithOptions(cutSize, YES, scale);
    } else {
        UIGraphicsBeginImageContext(cutSize);
    }
    
    // 获取截图
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *cutImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭context
    UIGraphicsEndImageContext();
    return cutImage;
}




// 把大于500*500图片压至500*500
+ (UIImage *)compressImage:(UIImage *)img
{
    if (img.size.width <= 500) {
        return img;
    }
    
    
    CGSize size = {500, 500};
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [img drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}

// 把大于size的图片压缩，
+ (UIImage *)compressImage:(UIImage *)img  toSize:(CGSize)size
{
    if (img.size.width <= size.width || img.size.height <= size.height) {
        return img;
    }
    
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }

    CGRect rect = {{0,0}, size};
    [img drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImg;
}

// 通过文件名找到所在路径，根据路径把照片加载入data,以数据的方式获取img,节省内存
+ (UIImage *)imageFromDataNamed:(NSString *)imgName
{
    // 如果imgName里面不包含@2x,把@2x加进去
    NSRange range = [[imgName lowercaseString]rangeOfString:@"@2x"];
    if (range.location == NSNotFound) {
        NSString *extension = [imgName pathExtension];
        if (extension.length == 0) {
            extension = @"png";
        }
        NSString *onlyName = [imgName stringByDeletingPathExtension];
        onlyName = [onlyName stringByAppendingString:@"@2x"];
        imgName = [onlyName stringByAppendingPathExtension:extension];
    }
    
    // 获取路径，取得data,返回image
    NSString *imgPath = [[NSBundle mainBundle]pathForResource:imgName ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:imgPath];
    return [UIImage imageWithData:data];
}


// 生成一张纯色图片
- (UIImage *)initWithSize:(CGSize)size color:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}



// 返回image的字节数
- (NSUInteger)kilobyte
{
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    return data.length / 1024;
}



- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
//    UIGraphicsBeginImageContext(targetSize); // this will crop
//    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 2.0);
    
    static CGFloat scale = -1.0;
    if (scale < 0.0) {
        UIScreen *screen = [UIScreen mainScreen];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
            scale = [screen scale];
        } else {
            scale = 0.0;    // mean use old api
        }
    }
    
    if (scale > 0.0) {
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, scale);
    } else {
        UIGraphicsBeginImageContext(targetSize);
    }
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName
{
    return [self resizedImage:imgName xPos:0.5 yPos:0.5];
}


+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos
{
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}
@end
