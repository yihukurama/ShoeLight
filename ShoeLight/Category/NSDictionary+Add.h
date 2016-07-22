//
//  NSDictionary+Add.h
//  NewGS
//
//  Created by newgs_mac on 14/12/23.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>

@interface NSDictionary (Add)

- (NSString *)stringForKey:(NSString *)key;

- (NSNumber *)numForKey:(NSString *)key;

- (int)intForKey:(NSString *)key;

//- (CGFloat)floatForKey:(NSString *)key;

- (NSArray *)arrayForKey:(NSString *)key;

- (NSDictionary *)dictForKey:(NSString *)key;

- (BOOL)boolForKey:(NSString *)key;


@end
