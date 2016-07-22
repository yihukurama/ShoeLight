//
//  RunVC.h
//  ShoeLight
//
//  Created by even on 16/2/14.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

typedef enum : NSUInteger {
    RunStateIdle = 0,
    RunStateRun,
    RunStatePause,
} RunState;

@interface RunVC : BaseVC

- (void)tabBarVCWillDismiss;

@end
