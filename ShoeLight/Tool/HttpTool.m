//
//  HttpTool.m
//  
//
//  Created by zhaoyd on 14-5-24.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//
#define kRequestManager  [AFHTTPRequestOperationManager manager]
#define kDefautTimeoutInterval 15.0f

#import <AFNetworking.h>
#import "HttpTool.h"
#import "macro.h"
#import "NSDictionary+Add.h"


@implementation HttpTool

#pragma mark - Public

/**
 *  上传图片上数据
 *
 *  @param imageData image Data数据
 *  @param params    参数
 *  @param success   返回json ret=1时回调
 *  @param failure   返回json ret=0时回调
 */
+ (void)uploadImageData:(NSData *)imageData
                 params:(NSDictionary *)params
                success:(SuccessBlock)success
                failure:(RequestFailBlock)failure {
//    NSString *imageStr = [Base64 stringByEncodingData:imageData];
//
//    MyLog(@"上传图片转成base64字符串的长度为：%zdk  data长度：%.0f kb",imageStr.length / 1024,(CGFloat)imageData.length/ 1024);
//    
//    NSMutableDictionary *paramsM = [NSMutableDictionary dictionary];
//    [paramsM setValue:imageStr forKey:@"img"];
//    if (params) {
//        [paramsM setValuesForKeysWithDictionary:params];
//    }
//    
//    [self postWithPath:@"upload.php/Index/upload_from_app"
//                params:paramsM
//       timeoutInterval:60.0f
//               success:success
//               failure:failure];
}

/**
 *  post
 *
 *  @param path    子路径
 *  @param params  请求参数
 *  @param success 返回json ret=1时回调
 *  @param failure 返回json ret=0时回调
 */
+ (void)postWithSubPath:(NSString *)path
                 params:(NSDictionary *)params
                success:(SuccessBlock)success
                failure:(RequestFailBlock)failure
{
    [self postWithPath:path
                params:params
       timeoutInterval:kDefautTimeoutInterval
               success:success
               failure:failure];
}

/**
 *  post
 *
 *  @param path    子路径或者全路径
 *  @param params  请求参数
 *  @param timeoutInterval  请求超时时间
 *  @param success 返回json ret=1时回调
 *  @param failure 返回json ret=0时回调
 */
+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
     timeoutInterval:(CGFloat)timeoutInterval
             success:(SuccessBlock)success
             failure:(RequestFailBlock)failure
{
    NSDictionary *fullParams = [self fullParamsWithParams:params];
    NSString *fullPath = [self fullPathWithSubPath:path];
    NSLog(@"\n\n发起POST请求：%@%@\n\n",fullPath,[self paramsStringWithParams:fullParams]);
    
    // 设置超时时间 [AFHTTPRequestOperationManager manager]
    AFHTTPRequestOperationManager *manager    = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:fullPath parameters:fullParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self handleSuccesResponseObject:responseObject
                              ofFullPath:fullPath
                                  params:fullParams
                                 success:success
                                 failure:failure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self handleFailureError:error
                      ofFullPath:fullPath
                         failure:failure];
    }];
}

/**
 *  post
 *
 *  @param port    端口
 *  @param subPath 子路径
 *  @param params  请求参数
 *  @param success 返回json ret=1时回调
 *  @param failure 返回json ret=0时回调
 */
+ (void)postWithPort:(NSString *)port
             subPath:(NSString *)subPath
              params:(NSDictionary *)params
             success:(SuccessBlock)success
             failure:(RequestFailBlock)failure
{
    
    NSString *path = kBaseURL;
    if (port.length) {
        path = [NSString stringWithFormat:@"%@:%@",path,port];
    }
    
    if (subPath.length) {
        path = [NSString stringWithFormat:@"%@/%@",path,subPath];
    }
    
    [self postWithPath:path
                params:params
       timeoutInterval:kDefautTimeoutInterval
               success:success
               failure:failure];
}

/**
 *  post
 *
 *  @param path    全路径
 *  @param params  请求参数
 *  @param success 返回json ret=1时回调
 *  @param failure 返回json ret=0时回调
 */
+ (void)postWithFullPath:(NSString *)path
                  params:(NSDictionary *)params
                 success:(SuccessBlock)success
                 failure:(RequestFailBlock)failure
{
    [self postWithPath:path
                params:params
       timeoutInterval:kDefautTimeoutInterval
               success:success
               failure:failure];
}

/**
 *  GET
 *
 *  @param path    子路径
 *  @param params  请求参数
 *  @param success 返回json ret=1时回调
 *  @param failure 返回json ret=0时回调
 */
+ (void)getWithSubPath:(NSString *)path
                params:(NSDictionary *)params
               success:(SuccessBlock)success
               failure:(RequestFailBlock)failure
{
    [self getWithPath:path
               params:params
      timeoutInterval:kDefautTimeoutInterval
              success:success
              failure:failure];
}

/**
 *  GET
 *
 *  @param path    全路径
 *  @param params  请求参数
 *  @param success 返回json ret=1时回调
 *  @param failure 返回json ret=0时回调
 */
+ (void)getWithFullPath:(NSString *)path
                params:(NSDictionary *)params
               success:(SuccessBlock)success
               failure:(RequestFailBlock)failure
{
    
    
    [self getWithPath:path
               params:params
      timeoutInterval:kDefautTimeoutInterval
              success:success
              failure:failure];
}

/**
 *  GET
 *
 *  @param port    端口
 *  @param subPath 子路径
 *  @param params  请求参数
 *  @param success 返回json ret=1时回调
 *  @param failure 返回json ret=0时回调
 */
+ (void)getWithPort:(NSString *)port
            subPath:(NSString *)subPath
             params:(NSDictionary *)params
            success:(SuccessBlock)success
            failure:(RequestFailBlock)failure
{
    
    NSString *path = kBaseURL;
    if (port.length) {
        path = [NSString stringWithFormat:@"%@:%@",path,port];
    }
    
    if (subPath.length) {
        path = [NSString stringWithFormat:@"%@/%@",path,subPath];
    }
    
    [self getWithPath:path
                params:params
       timeoutInterval:kDefautTimeoutInterval
               success:success
               failure:failure];
}

/**
 *  GET
 *
 *  @param path    子路径或者全路径
 *  @param params  请求参数
 *  @param timeoutInterval  请求超时时间
 *  @param success 返回json ret=1时回调
 *  @param failure 返回json ret=0时回调
 */
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
    timeoutInterval:(CGFloat)timeoutInterval
            success:(SuccessBlock)success
            failure:(RequestFailBlock)failure
{
    NSDictionary *fullParams = [self fullParamsWithParams:params];
    NSString *fullPath = [self fullPathWithSubPath:path];
    
    NSLog(@"\n\n发起GET请求：%@%@\n\n",fullPath,[self paramsStringWithParams:params]);
    
    // 设置超时时间 [AFHTTPRequestOperationManager manager]
    AFHTTPRequestOperationManager *manager    = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:fullPath parameters:fullParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self handleSuccesResponseObject:responseObject
                              ofFullPath:fullPath
                                  params:fullParams
                                 success:success
                                 failure:failure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self handleFailureError:error
                      ofFullPath:fullPath
                         failure:failure];
    }];
}

#pragma mark - Private
/**
 *  根据一个子路径生成全路径
 *
 *  @param subPath 子路径
 *
 *  @return 全路径
 */
+ (NSString *)fullPathWithSubPath:(NSString *)subPath
{
    if ([subPath containsString:@"http://"] || [subPath containsString:@"https://"]) {
        // 异常处理，当传入的是一个全路径,直接返回
        return subPath;
    } else {
        return [NSString stringWithFormat:@"%@/%@",kBaseURL,subPath];
    }
}

/**
 *  给请求参数添加上app
 *
 *  @param params 求参数
 *
 *  @return 带app=method 的参数
 */
+ (NSDictionary *)fullParamsWithParams:(NSDictionary *)params
{
    // 拼接传进来的参数
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionary];
    if (params) {
        [fullParams setDictionary:params];
    }
    
    // 拼接method
    [fullParams setObject:@"app" forKey:@"method"];
    NSString *softVersion = kInfoDict[kBundleVersionKey];
    [fullParams setObject:softVersion forKey:@"softVersion"];
    [fullParams setObject:@"iOS" forKey:@"deviceType"];
    return fullParams;
}

/**
 *  打印请求返回的数据
 *
 *  @param responseObject 网络请求的响应数据
 *  @param fullPath       请求的地址
 */
+ (void)logResponseObject:(id)responseObject OfFullPath:(NSString *)fullPath params:(NSDictionary *)params
{
    if (responseObject == nil) {
        NSLog(@"打印网络请求返回数据时，返回的数据为空");
        return;
    }
    
    // 打印
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    MyLog(@"\n\n↑↑↑ %@%@ \n↓↓↓\n%@\n\n",fullPath,[self paramsStringWithParams:params],jsonString);
}

/**
 *  处理请求成功后的数据
 *
 *  @param responseObject responseObject
 *  @param path           路径
 *  @param params         参数
 *  @param success        成功后回调
 *  @param failure        失败后回调
 */
+ (void)handleSuccesResponseObject:(id)responseObject
                        ofFullPath:(NSString *)fullPath
                            params:(NSDictionary *)params
                           success:(SuccessBlock)success
                           failure:(RequestFailBlock)failure
{
    
    if (![responseObject isKindOfClass:[NSDictionary class]] && responseObject) {
        failure(RequestResultTypeHandleFail,@"数据格式错误",responseObject);
        return;
    } else if (responseObject == nil) {
        return;
    }
    
    NSDictionary *responseDict = (NSDictionary *)responseObject;
    if (responseDict[@"error"] == nil) {
#if DEBUG
        // 打印返回信息
        [self logResponseObject:responseObject OfFullPath:fullPath params:params];
#endif
        
        id JSON = responseObject;
        if (JSON == nil) {
            NSLog(@"服务器返回的JSON数据为空");
            return;
        }
        
        // 判断返回信息
        if (JSON[@"code"]) {
            int result = [JSON intForKey:@"code"];
            if (result == RequestResultTypeHandleSuccess) {
                // 当返回值为1时，调用success
                if (success) {
                    success(JSON);
                }
            } else {
                NSString *msg = [JSON stringForKey:@"message"];
                // 调用failure
                if (failure) {
                    failure(result,msg,JSON);
                }
            }
        } else {
            MyLog(@"服务器返回的JSON数据里没有code这个值");
        }
    } else {
        failure(RequestResultTypeHandleFail,@"网络请求出错",responseDict);
    }
}

/**
 *  处理请求失败后的数据
 *
 *  @param error    error
 *  @param fullPath 全路径
 *  @param failure  失败后回调
 */
+ (void)handleFailureError:(NSError *)error
                ofFullPath:(NSString *)fullPath
                   failure:(RequestFailBlock)failure
{
    //网络超时
    if (error.code == - 1300)
    {
        [kHudTool hideHudWithAnimation:YES];
    }
    
    NSLog(@"失败的请求：%@\n error:%@",fullPath,error);
    if (failure) {
        failure(RequestResultTypeConnectionFail,error.localizedDescription,nil);
    }
}

// 把请求参数字典转换成get参数样式的字符串
+ (NSString *)paramsStringWithParams:(NSDictionary *)params
{
    __block NSMutableString *string = [NSMutableString string];
    
    if (params.allKeys.count) {
        [string appendString:@"?"];
    }
    
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([string hasSuffix:@"?"]) {
            [string appendString:[NSString stringWithFormat:@"%@=%@",key,obj]];
        } else {
            [string appendString:[NSString stringWithFormat:@"&%@=%@",key,obj]];
        }
    }];
    return string;
}
@end
