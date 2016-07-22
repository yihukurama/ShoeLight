//
//  AlarmTouchView.m
//  ShoeLight
//
//  Created by even on 16/4/12.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "AlarmTouchView.h"

@implementation AlarmTouchView


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];

    int index = point.x / (self.frame.size.width / 5);
    if (self.chooseIndexBlock) {
        self.chooseIndexBlock(index);
    }
}

@end
