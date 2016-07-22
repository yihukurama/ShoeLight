//
//  AlarmTouchView.h
//  ShoeLight
//
//  Created by even on 16/4/12.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "macro.h"

@interface AlarmTouchView : UIView

@property (copy, nonatomic) void (^chooseIndexBlock)(int index);

@end
