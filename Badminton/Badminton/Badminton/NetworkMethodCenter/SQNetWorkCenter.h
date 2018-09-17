//
//  NetWorkingCenter.h
//  SnquADDemo
//
//  Created by 李俊 on 15/7/24.
//  Copyright (c) 2015年 SNQU. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void (^DownloadProgressBlock)(float currentReadBytes);



@interface SQNetWorkCenter : NSObject

/*
 * @param get 请求
 * @param url 请求链接
 * @param parmeter 参数
 * @param parmeter block (content：返回处理过的数据（字典） status:是否是一个返回正确的请求)
 */
+(void)requestDataofUrl:(NSString *)url
           andParmeters:(NSDictionary *)parmeter
           getWithBlock:(void (^)(id content, BOOL status))compate;

/*
 * @param post 请求
 * @param url 请求链接
 * @param parmeter 参数
 * @param parmeter block (content：返回处理过的数据（字典） status:是否是一个返回正确的请求)
 */
+(void)requestDataofUrl:(NSString *)url
           andParmeters:(NSDictionary *)parmeter
          postWithBlock:(void (^)(id content, BOOL status))compate;
/*
 * @param delete 请求
 * @param url 请求链接
 * @param parmeter 参数
 * @param parmeter block (content：返回处理过的数据（字典） status:是否是一个返回正确的请求)
 */
+ (void)requestDataofUrl:(NSString *)url
            andParmeters:(NSDictionary *)parmeter
         deleteWithBlock:(void (^)(id content, BOOL status))compate;

/*
 * @param put 请求
 * @param url 请求链接
 * @param parmeter 参数
 * @param parmeter block (content：返回处理过的数据（字典） status:是否是一个返回正确的请求)
 */
+ (void)requestDataofUrl:(NSString *)url
            andParmeters:(NSDictionary *)parmeter
            putWithBlock:(void (^)(id content, BOOL status))compate;


/**
 * url: 上传地址
 * parmeter:上传参数
 * key: 文件对应的KEY
 * imageDataArray:image的二进制数组(支持多张)
 **/
+(void)requestUploadingOfUrl:(NSString *)url andParmeters:(NSDictionary *)parmeter andFileKey:(NSString *)name andimageDataArray:(NSArray *)imageDataArray potsWithBlock:(void (^)(id content,BOOL state))compate;

/*
 * @param str MD5加密值
 */
+ (NSString *)md5:(NSString *)str;

+ (NSString *)toJSONString:(NSArray *)array;
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
