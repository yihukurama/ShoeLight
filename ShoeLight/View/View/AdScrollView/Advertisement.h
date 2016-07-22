//
//  Advertisement.h
//  NewGS
//
//  Created by newgs_mac on 15/1/15.
//  Copyright (c) 2015年 cnmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advertisement : NSObject <NSCoding>

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *linkUrl;
@property (copy, nonatomic) NSString *imageUrl;

- (Advertisement *)initWithDict:(NSDictionary *)dict;
+ (Advertisement *)advertisementWithName:(NSString *)name linkUrl:(NSString *)linkUrl imageUrl:(NSString *)imageUrl;

@end
