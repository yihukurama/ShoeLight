//
//  HttpTool.h
//  
//
//  Created by zhaoyd on 14-5-24.
//  Copyright (c) 2014年 cnmobi. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id obj);
typedef void(^FailureBlock)(id obj,NSError *error);



/** 服务器请求结果状态*/
//typedef NS_ENUM(NSInteger, RequestResultType) {
//    RequestResultTypeHandleFail     = 0,/** 与服务器连接成功，但是处理失败，ret返回为0 */
//    RequestResultTypeHandleSuccess  = 1,/** 与服务器连接成功，并处理成功，ret返回为1 */
//    RequestResultTypeAuthFail = 2,/** 与服务器连接身份认证失败 */
//    RequestResultTypeConnectionFail = 404,/** 与服务器连接失败 */
//};

typedef enum : NSInteger {
    RequestResultTypeTest = -100,
    RequestResultTypeHandleAccountChecking     = -3,
    RequestResultTypeHandleNoInvite     = -2,
    RequestResultTypeHandleUpper         = -1,
    RequestResultTypeHandleFail     = 0,    /** 与服务器连接成功，但是处理失败，ret返回为0 */
    RequestResultTypeHandleSuccess  = 1000,    /** 与服务器连接成功，并处理成功，ret返回为1 */
    RequestResultTypeAuthFail = 2,          /** 与服务器连接身份认证失败 */
    RequestResultTypeConnectionFail = 404,  /** 与服务器连接失败 */
} RequestResultType;


/**
 *  发送请求给服务器，服务器处理失败回调
 *
 *  @param msg      服务器请求失败的返回的文字
 *  @param failType 服务器请求失败的类型
 */

typedef void(^RequestFailBlock) (RequestResultType failType, NSString *msg,NSDictionary *json);

@interface HttpTool : NSObject

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
                failure:(RequestFailBlock)failure;
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
                failure:(RequestFailBlock)failure;

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
                 failure:(RequestFailBlock)failure;

+ (void)postWithPort:(NSString *)port
             subPath:(NSString *)subPath
              params:(NSDictionary *)params
             success:(SuccessBlock)success
             failure:(RequestFailBlock)failure;

+ (void)getWithSubPath:(NSString *)path
                params:(NSDictionary *)params
               success:(SuccessBlock)success
               failure:(RequestFailBlock)failure;

+ (void)getWithFullPath:(NSString *)path
                 params:(NSDictionary *)params
                success:(SuccessBlock)success
                failure:(RequestFailBlock)failure;

+ (void)getWithPort:(NSString *)port
            subPath:(NSString *)subPath
             params:(NSDictionary *)params
            success:(SuccessBlock)success
            failure:(RequestFailBlock)failure;


@end
