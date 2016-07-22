

#import <Foundation/Foundation.h>

@interface NSString (Helper)

// 是否包含某个字符串
- (BOOL)containsString:(NSString *)aString;

// 清空字符串中的空白字符
- (NSString *)trimString;

// 是否空字符串
- (BOOL)isEmptyString;

// 写入系统偏好
- (void)saveToNSDefaultsWithKey:(NSString *)key;

// 删除符号：()-空格
- (NSString*)trimSymbol;

// 判断手机号码是否正确
- (BOOL)isPhoneNum;

// 判断是否是邮箱
- (BOOL)isEmail;

// 判断长度是否处于num1和num2之间
- (BOOL)isLengthBetween:(int)num1 and:(int)num2;


// 生成一个唯一字符串
+ (NSString *)uniqueId;

// json
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;


@end
