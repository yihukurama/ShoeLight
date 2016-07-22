//
//  FFTTool.m
//  ShoeLight
//
//  Created by even on 16/4/7.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "FFTTool.h"
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>




#define maxColor  255
#define middleColor  128
#define minColor 0

@interface FFTTool()

@property (nonatomic, assign) int LAST_SUM;
@property (nonatomic, assign) int LAST_RED;
@property (nonatomic, assign) int LAST_GREEN;
@property (nonatomic, assign) int LAST_BLUE;
@property (nonatomic, assign) int green;
@property (nonatomic, assign) int red;
@property (nonatomic, assign) int blue;


@end


@implementation FFTTool


+ (FFTTool *)sharedInstance
{
    static FFTTool *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.LAST_SUM = 15000;
        sharedInstance.LAST_RED = 255;
        sharedInstance.LAST_GREEN = 255;
        sharedInstance.LAST_BLUE = 255;
        sharedInstance.green = 128;
        sharedInstance.blue = 128;
        sharedInstance.red = 128;
        
    });
    return sharedInstance;
}


/**
 * 根据频率比重最大得到颜色
 *
 * @param fft
 * @return
 */
- (NSInteger)getColorWithFFT:(float *)fft length:(NSInteger)length{
    
//    if ([self systemVolume] == 0) {
//        return 0;
//    }
    
    
    NSArray *model = [self fft2Model:fft length:length];
    CGFloat sum = 0;
    
    for (int i = 0; i < model.count; i++) {
        sum += [model[i] floatValue] * (i + 1);
    }
    
    
    if (sum < self.LAST_SUM && sum != 0) {
        sum = self.LAST_SUM - (self.LAST_SUM - sum) * 0.3;
    } else {
        sum = self.LAST_SUM + (sum - self.LAST_SUM) * 0.5;
    }
    
    self.LAST_SUM = sum;
    return  sum;
//    NSInteger color = [self setColorByW:sum];
//    NSLog(@"maxFFT %@",@(maxNum));
//    return color;
}

/**
 * 设置颜色
 *
 * @param w
 * @return
 */
- (NSInteger)setColorByW:(int)sum {
    
    NSLog(@"sum%@",@(sum));
    
//    int KEY_5W = 50000;
    int KEY_10W = 100000;
    int KEY_20W = 200000;
//    int KEY_25W = 250000;
    NSInteger color = [self argbWithAlpha:255 R:3 G:3 B:3];
    int current = 1;
    if(sum==0||current==0){
        color = 0;

    } else if (sum < KEY_10W) {
        int tmpRed = self.red * (sum / self.LAST_SUM);
        int tmpGeen = self.green * (sum / self.LAST_SUM);
        int tmpBlue = self.blue * (sum / self.LAST_SUM);
        

        color = [self argbWithAlpha:255
                                  R: tmpRed < minColor ? minColor : tmpRed
                                  G: tmpGeen < minColor ? minColor : tmpGeen
                                  B: tmpBlue < minColor ? minColor : tmpBlue];
        
    } else if (sum >= KEY_20W) {
        
        int tmpRed = self.red * (sum / self.LAST_SUM);
        int tmpGeen = self.green * (sum / self.LAST_SUM);
        int tmpBlue = self.blue * (sum / self.LAST_SUM);
        
        
        color = [self argbWithAlpha:255
                                  R: tmpRed < minColor ? maxColor : tmpRed
                                  G:tmpGeen < minColor ? maxColor : tmpGeen
                                  B:tmpBlue < minColor ? maxColor : tmpBlue];
        
    } else if (sum >= KEY_10W && sum < KEY_20W) {
        // 重点处理区域
        if (sum > self.LAST_SUM) {
            [self color2LightWithSum:(sum - self.LAST_SUM) / 125 change:true];
        } else if (sum <= self.LAST_SUM) {
            [self color2LightWithSum:(self.LAST_SUM - sum) / 125 change:false];
        }
        self.LAST_SUM = sum;
        color = [self argbWithAlpha:255
                                  R: self.red
                                  G: self.green
                                  B: self.blue];
    }
    
    return color;
}

- (void)color2LightWithSum:(int)sum change:(BOOL) change {
    
    int fBlue = 0, fRed = 0;
    
    if (change) {
        while (sum >= 0) {
            
            self.blue++;
            if (self.blue > maxColor) {
                
                if (self.red == maxColor) {
                    self.blue = maxColor;
                    self.green++;
                    if (self.green > maxColor) {
                        self.green = maxColor;
                    }
                } else {
                    
                    self.blue = minColor;
                    self.red += maxColor / 2.6;
                    if (self.red > maxColor) {
                        if ((self.green + maxColor / 1.6) > maxColor) {
                            self.red = maxColor;
                        } else {
                            self.red = minColor;
                            self.green += maxColor / 1.6;
                            if (self.green > maxColor) {
                                self.green = maxColor;
                            }
                        }
                        
                    }
                }
            }
            
            fBlue++;
            if (fBlue == 2) {
                
                fBlue = 0;
                
                self.red++;
                if (self.red > maxColor) {
                    if ((self.green + maxColor / 1.6) > maxColor) {
                        self.red = maxColor;
                    } else {
                        self.red = minColor;
                        self.green += maxColor / 1.6;
                    }
                    if (self.green > maxColor) {
                        self.green = maxColor;
                    }
                }
                
                fRed++;
                if (fRed == 5 && self.red != maxColor) {
                    
                    fRed = 0;
                    
                    self.green++;
                    if (self.green > maxColor) {
                        self.green = maxColor;
                    }
                }
            }
            sum--;
            /*
             * System.out.println("当前 sum: " + sum);
             * System.out.println("当前 亮度: " + getLight(green, red, blue));
             * System.out.println("当前 G R B: " + green + " " + red + " " +
             * blue + "\n");
             */
        }
    } else {
        while (sum >= 0) {
            
            self.blue--;
            if (self.blue < minColor) {
                
                if (self.red == minColor) {
                    self.blue = minColor;
                    self.green--;
                    if (self.green < minColor) {
                        self.green = minColor;
                    }
                } else {
                    
                    self.blue = maxColor;
                    self.red -= maxColor / 2.6;
                    if (self.red < minColor) {
                        if ((self.green - maxColor / 1.6) < minColor) {
                            self.red = minColor;
                        } else {
                            self.red = maxColor;
                            self.green -= maxColor / 1.6;
                            if (self.green < minColor) {
                                self.green = minColor;
                            }
                        }
                    }
                }
            }
            
            fBlue++;
            if (fBlue == 2) {
                
                fBlue = 0;
                
                self.red--;
                if (self.red < minColor) {
                    if ((self.green - maxColor / 1.6) < minColor) {
                        self.red = minColor;
                    } else {
                        self.red = maxColor;
                        self.green -= maxColor / 1.6;
                        if (self.green < minColor) {
                            self.green = minColor;
                        }
                    }
                }
                
                fRed++;
                if (fRed == 5 && self.red != minColor) {
                    
                    fRed = 0;
                    
                    self.green--;
                    if (self.green < minColor) {
                        self.green = minColor;
                    }
                }
            }
            sum--;
        }
    }
    
}


/**
 * fft转成振幅
 * 
 * @param fft
 * @return
 */
- (NSArray *)fft2Model:(float *)fft length:(NSInteger)length{
    NSMutableArray *model = [NSMutableArray arrayWithCapacity:length / 2 + 1];
    model[0] = @(fabsf(fft[0]));
    for (int i = 2, j = 1; i < length - 1; i += 2, j++) {
        model[j] = @(sqrt(fft[i] * fft[i] + fft[i + 1] * fft[i + 1]));
    }
    return model;
}


- (NSInteger)argbWithAlpha:(int)alpha R:(int)red G:(int)green B:(int)blue  {
    
    NSInteger a = alpha;
    NSInteger r = red;
    NSInteger g = green;
    NSInteger b = blue;
     return (a << 24) | (r << 16) | (g << 8) | b;
}






@end
