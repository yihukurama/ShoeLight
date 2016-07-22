//
//  MyProfileTool.m
//  NewGS
//
//  Created by zhaoyd on 14-11-13.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

#import "MyProfileTool.h"
#import "NSDictionary+Add.h"
#import "macro.h"
#import "UserDefault.h"

@implementation MyProfileTool
single_implementation(MyProfileTool)


#pragma mark - Public

// 根据下载的字典配置自己的信息
- (void)configureWithDict:(NSDictionary *)loginUserDict
{
    if (loginUserDict == nil) {
        return;
    }
}

#pragma mark - Public
- (void)logout {
}


#pragma mark - Getter && Setter
- (NSString *)gender {
    return UserDefaultString(@"MyProfileTool_gender");
}
- (void)setGender:(NSString *)gender {
    SetUserDefaultObject(@"MyProfileTool_gender", gender);
}

- (NSInteger)age {
    return UserDefaultInteger(@"MyProfileTool_age");
}
- (void)setAge:(NSInteger)age {
    SetUserDefaultInteger(@"MyProfileTool_age", age);
}

- (NSInteger)weight {
    return UserDefaultInteger(@"MyProfileTool_weight");
}
- (void)setWeight:(NSInteger)weight {
    SetUserDefaultInteger(@"MyProfileTool_weight", weight);
}

- (NSInteger)height {
    return UserDefaultInteger(@"MyProfileTool_height");
}
- (void)setHeight:(NSInteger)height{
    SetUserDefaultInteger(@"MyProfileTool_height", height);
}


- (NSString *)deviceVersion {
    return UserDefaultString(@"MyProfileTool_deviceVersion");
}
- (void)setDeviceVersion:(NSString *)deviceVersion {
    SetUserDefaultObject(@"MyProfileTool_deviceVersion", deviceVersion);
}

//- (bool)alarmEnabled {
//    return UserDefaultInteger(@"MyProfileTool_alarmEnabled");
//}
//- (void)setAlarmEnabled:(bool)alarmEnabled {
//    SetUserDefaultInteger(@"MyProfileTool_alarmEnabled", alarmEnabled);
//}

- (bool)isEnglish {
    return UserDefaultInteger(@"MyProfileTool_isEnglish");
}
- (void)setIsEnglish:(BOOL)isEnglish {
    SetUserDefaultInteger(@"MyProfileTool_isEnglish", isEnglish);
}

//- (NSString *)alarmName {
//    return UserDefaultObject(@"MyProfileTool_alarmName");
//}
//- (void)setAlarmName:(NSString *)alarmName {
//    SetUserDefaultObject(@"MyProfileTool_alarmName", alarmName);
//}
//
//- (NSInteger)alarmTime {
//    return UserDefaultInteger(@"MyProfileTool_alarmTime");
//}
//- (void)setAlarmTime:(NSInteger)alarmTime {
//    SetUserDefaultInteger(@"MyProfileTool_alarmTime", alarmTime);
//}
//
//- (CGFloat)alarmVolume {
//    return UserDefaultFloat(@"MyProfileTool_alarmVolume");
//}
//-  (void)setAlarmVolume:(CGFloat)alarmVolume {
//    SetUserDefaultFloat(@"MyProfileTool_alarmVolume", alarmVolume);
//}

- (NSInteger)currentStep {
    return UserDefaultInteger(@"MyProfileTool_currentStep");
}
- (void)setCurrentStep:(NSInteger)currentStep {
    SetUserDefaultInteger(@"MyProfileTool_currentStep", currentStep);
}


- (NSInteger)storedSeconds {
    return UserDefaultInteger(@"MyProfileTool_storedSeconds");
}
- (void)setStoredSeconds:(NSInteger)storedSeconds {
    SetUserDefaultInteger(@"MyProfileTool_storedSeconds", storedSeconds);
}

- (NSDate *)startDate {
    return UserDefaultObject(@"MyProfileTool_startDate");
}
- (void)setStartDate:(NSDate *)startDate {
    SetUserDefaultObject(@"MyProfileTool_startDate", startDate);
}

- (CGFloat)currentDistance {
    return UserDefaultFloat(@"MyProfileTool_currentDistance");
}
- (void)setCurrentDistance:(CGFloat)currentDistance {
    SetUserDefaultFloat(@"MyProfileTool_currentDistance", currentDistance);
}

- (NSDate *)lastStepDataDate {
    return UserDefaultObject(@"MyProfileTool_lastStepDataDate");
}
- (void)setLastStepDataDate:(NSDate *)lastStepDataDate {
    SetUserDefaultObject(@"MyProfileTool_lastStepDataDate", lastStepDataDate);
}

- (CGFloat)currentSpeed {
    return UserDefaultFloat(@"MyProfileTool_currentSpeed");
}
-  (void)setCurrentSpeed:(CGFloat)currentSpeed {
    SetUserDefaultFloat(@"MyProfileTool_currentSpeed", currentSpeed);
}

///* 累积记录 */
//@property (assign, nonatomic) NSInteger totalStep;
//@property (assign, nonatomic) NSInteger totalDistance;
//@property (assign, nonatomic) NSInteger totalTime;

- (NSInteger)totalStep {
    return UserDefaultInteger(@"MyProfileTool_totalStep");
}
- (void)setTotalStep:(NSInteger)totalStep {
    SetUserDefaultInteger(@"MyProfileTool_totalStep", totalStep);
}

- (void)setTotalDistance:(NSInteger)totalDistance {
    SetUserDefaultInteger(@"MyProfileTool_totalDistance", totalDistance);
}
- (NSInteger)totalDistance {
    return UserDefaultInteger(@"MyProfileTool_totalDistance");
}

- (void)setTotalTime:(NSInteger)totalTime {
    SetUserDefaultInteger(@"MyProfileTool_totalTime", totalTime);
}
- (NSInteger)totalTime {
    return UserDefaultInteger(@"MyProfileTool_totalTime");
}
@end
