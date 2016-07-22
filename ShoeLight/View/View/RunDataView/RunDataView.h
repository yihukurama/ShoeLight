//
//  RunDataView.h
//  ShoeLight
//
//  Created by even on 16/2/14.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Run;

@interface RunDataView : UIView

@property (assign, nonatomic) BOOL isTotal;

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *distenceLbl;
@property (weak, nonatomic) IBOutlet UILabel *speedLbl;
@property (weak, nonatomic) IBOutlet UILabel *calorieLbl;
@property (strong, nonatomic) Run *run;
+ (RunDataView *)runDataView;
- (void)updateLanguage;
- (void)clearData;
@end
