//
//  Advertisement.m
//  NewGS
//
//  Created by newgs_mac on 15/1/15.
//  Copyright (c) 2015年 cnmobi. All rights reserved.
//

#import "Advertisement.h"
#import "NSDictionary+Add.h"

@implementation Advertisement


- (id)initWithCoder:(NSCoder *)aDecoder
{
    _name = [aDecoder decodeObjectForKey:@"name"];
    _linkUrl = [aDecoder decodeObjectForKey:@"linkUrl"];
    _imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:self.linkUrl forKey:@"linkUrl"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
}


- (Advertisement *)initWithDict:(NSDictionary *)dict
{
//    Advertisement *ad = [[Advertisement alloc]init];
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        self.name = [dict stringForKey:@"name"];
        self.linkUrl = [dict stringForKey:@"linkurl"];
        self.imageUrl = [dict stringForKey:@"img"];
    }
    return self;
}


+ (Advertisement *)advertisementWithName:(NSString *)name linkUrl:(NSString *)linkUrl imageUrl:(NSString *)imageUrl {
    Advertisement *ad = [[Advertisement alloc]init];
    ad.name = name;
    ad.linkUrl = linkUrl;
    ad.imageUrl = imageUrl;
    return ad;
}
@end
