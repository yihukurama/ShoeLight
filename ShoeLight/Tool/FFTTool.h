//
//  FFTTool.h
//  ShoeLight
//
//  Created by even on 16/4/7.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FFTTool : NSObject

+ (FFTTool *)sharedInstance;

/**
 * 根据频率比重最大得到颜色
 *
 * @param fft
 * @return
 */
- (NSInteger)getColorWithFFT:(float *)fft length:(NSInteger)length;
@end
