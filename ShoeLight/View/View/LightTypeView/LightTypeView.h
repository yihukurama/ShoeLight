//
//  LightTypeView.h
//  ShoeLight
//
//  Created by even on 16/2/24.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightTypeView : UIView


@property (assign, nonatomic) NSInteger selectedIndex;
@property (copy, nonatomic) void (^valueChangedBlock)(NSInteger index);
@property (copy, nonatomic) BOOL (^shouldValueChangeBlock)(NSInteger index);


@end
