//
//  ClickSlider.m
//  ShoeLight
//
//  Created by even on 16/2/17.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "ClickSlider.h"
#import "UIResponder+Router.h"

@implementation ClickSlider

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGRect t = [self trackRectForBounds: [self bounds]];
    float v = [self minimumValue] + ([[touches anyObject] locationInView: self].x - t.origin.x - 4.0) * (([self maximumValue]-[self minimumValue]) / (t.size.width - 8.0));
    [self setValue: v];
    self.value = floorf(self.value + 0.5);
    
    [self routerEventWithName:@"ClickSlider" userInfo:nil];

    [super touchesBegan: touches withEvent: event];
}


@end
