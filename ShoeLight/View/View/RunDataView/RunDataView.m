//
//  RunDataView.m
//  ShoeLight
//
//  Created by even on 16/2/14.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "RunDataView.h"
#import "macro.h"
#import "Run.h"
#import "UIResponder+Router.h"
#import "UIView+Add.h"
#import "RunVC.h"

@interface RunDataView ()

@property (weak, nonatomic) IBOutlet UILabel *distanceTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *speedTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *calorieTextLbl;
@property (assign, nonatomic) BOOL iskmh;// 单位是否是km/h

@end

@implementation RunDataView


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        UIView *view = [[[UINib nibWithNibName:@"RunDataView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor = kGlbBgColor;
        [self addSubview:view];
        
        // 添加约束
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        NSDictionary *metrics = @{@"space":@(0)};
        NSString *vfl1 = @"|-space-[view]-space-|";
        NSString *vfl2 = @"V:|-space-[view]-space-|";
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:metrics views:views]];
        
        [self updateLanguage];
    }
    return self;
}

+ (RunDataView *)runDataView {
    RunDataView *view = [[[UINib nibWithNibName:@"RunDataView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [view updateLanguage];
    view.backgroundColor = kGlbBgColor;
    return view;
}

- (void)setIsTotal:(BOOL)isTotal {
    _isTotal = isTotal;
    [self updateLanguage];
}

- (void)updateLanguage {
    
    if (self.isTotal) {
        if (kMyProfileTool.isEnglish) {
            self.distanceTextLbl.text = @"All Mileage(km)";
            self.timeTextLbl.text = @"All Time(min)";
            self.speedTextLbl.text = @"Speed(m/s)";
            self.calorieTextLbl.text = @"All Calories(kCall)";
        } else {
            
            self.distanceTextLbl.text = @"累积里程(km)";
            self.timeTextLbl.text = @"累积时间(min)";
            self.speedTextLbl.text = @"平均速度(m/s)";
            self.calorieTextLbl.text = @"总卡路里(kCall)";
        }
    } else {
        if (kMyProfileTool.isEnglish) {
            self.distanceTextLbl.text = @"Mileage(km)";
            self.timeTextLbl.text = @"Time(min)";
            self.speedTextLbl.text = self.iskmh ? @"Speed(km/h)" : @"Speed(m/s)";
            self.calorieTextLbl.text = @"Calories(kCall)";
        } else {
            self.distanceTextLbl.text = @"里程(km)";
            self.timeTextLbl.text = @"时间(min)";
            self.speedTextLbl.text = self.iskmh ? @"速度(km/h)" : @"速度(m/s)";
            self.calorieTextLbl.text = @"卡路里(kCall)";
        }
    }
}

- (void)clearData {
    self.distenceLbl.text = @"0";
    self.timeLbl.text = @"00:00:00";
    self.speedLbl.text = @"0";
    self.calorieLbl.text = @"0";
}


- (void)setRun:(Run *)run {
    _run = run;
    
    self.timeLbl.text = [CommonTool hhmmssStrWithTimeInterval:(run.stopDate - run.startDate)];
    self.distenceLbl.text = [NSString stringWithFormat:@"%.2f",run.distance * 0.001];
    
    if (self.iskmh) {
        self.speedLbl.text = [NSString stringWithFormat:@"%.2f",run.distance / ((run.stopDate - run.startDate) * 3.6)];
    } else {
        self.speedLbl.text = [NSString stringWithFormat:@"%.2f",run.distance / (run.stopDate - run.startDate)];
    }
    
    self.calorieLbl.text = [CommonTool caloriesStrWithDistance:run.distance];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([self viewControllerWithClassName:@"RunVC"]) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        if (point.x < self.frame.size.width * 0.5 && point.y > self.frame.size.height * 0.5) {
            
            
            
            CGFloat speed = [self.speedLbl.text floatValue];
            if (self.iskmh) {
                speed *= 3.6;
            } else {
                speed /= 3.6;
            }
            
            self.iskmh = !self.iskmh;
            [self updateLanguage];
            
            if (speed) {
                self.speedLbl.text = [NSString stringWithFormat:@"%.2f",speed];
            } else {
                self.speedLbl.text = @"0";
            }
        }
    }
    

}

@end
