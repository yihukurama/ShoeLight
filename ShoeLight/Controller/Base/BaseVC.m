//
//  BaseVC.m
//  Sound
//
//  Created by even on 15/6/13.
//  Copyright (c) 2015年 even. All rights reserved.
//

#import "BaseVC.h"


@interface BaseVC () 

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [[BLE sharedInstance] setBleDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
//    [[BLE sharedInstance] setBleDelegate:nil];
}



@end
