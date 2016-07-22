//
//  RunDetailView.h
//  ShoeLight
//
//  Created by even on 16/2/14.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"
#import "Run+CoreDataProperties.h"
@class RunDataView;

@interface RunDetailView : UIView

+ (instancetype)runDetailView;

@property (assign, nonatomic) NSInteger step;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet RunDataView *runDataView;
@property (assign, nonatomic) BOOL isTotal;// 是否是累积
@property (strong, nonatomic) Run *run;
- (void)updateLanguage;

@end
