    //
//  NetWorkingCenter.m
//  SnquADDemo
//
//  Created by 高超林 on 15/7/24.
//  Copyright (c) 2015年 SNQU. All rights reserved.
//


#import "SQNetWorkCenter.h"
//#import <Reachability/Reachability.h>

#import <AFNetworking/AFNetworking.h>
static CGFloat const timeoutInterval = 15;


typedef NS_ENUM(NSInteger, NetWorkState) {
     NetWorkStateing = 0,//
     NetWorkStateNO = 1//无网络
};
static AFHTTPSessionManager *manager;

@interface SQNetWorkCenter()

@end



@implementation SQNetWorkCenter

//正常服务器请求单例
+ (AFHTTPSessionManager *)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 初始化请求管理类
        manager = [AFHTTPSessionManager manager];
        // 设置15秒超时 - 取消请求
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain", @"text/html",nil];
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        manager.responseSerializer = response;
        
         [[AFNetworkReachabilityManager sharedManager] startMonitoring];
         [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:{
                    NSLog(@"无网络");
//                    [NoNetWorkView show];
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi:{
                    NSLog(@"WiFi网络");
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWWAN:{
                    NSLog(@"无线网络");
                    break;
                }
                default:
                    break;
            }
        }];
    });
    return manager;
    
}


+(void)requestDataofUrl:(NSString *)url andParmeters:(NSDictionary *)parmeter getWithBlock:(void (^)(id content, BOOL status))compate{
     manager = [SQNetWorkCenter sharedManager];
//    [manager.requestSerializer setValue:@"_ga=GA1.2.1223663780.1536217591; _gid=GA1.2.788962855.1536217591" forHTTPHeaderField:@"CooKie"];
     manager.requestSerializer.timeoutInterval = timeoutInterval;
    [manager.requestSerializer setValue:@"badminton/3.1.0 (iPhone; iOS 11.4.1; Scale/3.00)" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"_ga=GA1.2.1223663780.1536217591; _gid=GA1.2.788962855.1536217591" forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:@"badminton" forHTTPHeaderField:@"database"];
    [manager GET:url parameters:parmeter progress:nil success:^(NSURLSessionDataTask *  task, id responseObject) {
        NSDictionary *content = responseObject;
        NSDictionary *contentDic = content;
        compate(contentDic,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error.code == -1001){
            compate(@"连接超时",NO);
        }else if (error.code == -1009){
            compate(@"网络断开",NO);
        }else{
            compate(@"数据获取失败，请稍后再试!",NO);
        }
    }];
  
}



+(void)requestDataofUrl:(NSString *)url andParmeters:(NSDictionary *)parmeter postWithBlock:(void (^)(id content, BOOL status))compate{
    manager = [SQNetWorkCenter sharedManager];
    manager.requestSerializer.timeoutInterval = timeoutInterval;

    [manager POST:url parameters:parmeter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *content = responseObject;
        BOOL status = NO;
        NSDictionary *contentDic = nil;
        if([content[@"code"] intValue] == 0){
            status = YES;
            if (![[content allKeys] containsObject:@"data"]) {
                contentDic = content;
            }else{
                contentDic = content[@"data"];
            }
        }else{
            //发现401 就登陆失败 需要在页面中处理
            contentDic = @{@"msg":content[@"message"],@"code":content[@"code"]};
        }
        if (compate) {
            compate(contentDic,status);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData * responseObject = [[NSData alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"]];
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments
                                                                  error:nil];
        if(error.code == -1001){
            compate(@{@"msg":@"连接超时"},NO);
        }else if([content[@"code"] integerValue] == 401){
            compate(content,NO);
        }else if (error.code == -1009){
            compate(@{@"msg":@"网络断开"},NO);
        }else{
            compate(@{@"msg":@"数据获取失败，请稍后再试!"},NO);
        }
    }];
}



+ (void)requestDataofUrl:(NSString *)url andParmeters:(NSDictionary *)parmeter deleteWithBlock:(void (^)(id content, BOOL status))compate{
    manager = [SQNetWorkCenter sharedManager];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    [manager DELETE:url parameters:parmeter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *content =  [NSDictionary dictionaryWithDictionary:responseObject];
        BOOL status = NO;
        NSDictionary *contentDic = nil;
        if([content[@"code"] intValue] == 0){
            status = YES;
            contentDic = content;
        }else{
            contentDic = @{@"msg":content[@"message"]};
        }
        if (compate) {
            compate(contentDic,status);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSData * responseObject = [[NSData alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"]];
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments
                                                                  error:nil];
        if([content[@"code"] intValue] == 200){
            if(compate){
                compate(content[@"message"],NO);
            }
        }else if(error.code == -1001){
            if (compate) {
                compate(@{@"data":@"连接超时"},NO);
            }
        }else if (error.code == -1009){
            if (compate) {
                compate(@"网络断开",NO);
            }
        }else{
            if (compate) {
                compate(@{@"data":@"服务器连接失败!"},NO);
            }
        }
    }];
}


+ (void)requestDataofUrl:(NSString *)url andParmeters:(NSDictionary *)parmeter
            putWithBlock:(void (^)(id content, BOOL status))compate{
    manager = [SQNetWorkCenter sharedManager];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    [manager PUT:url parameters:parmeter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *content =  [NSDictionary dictionaryWithDictionary:responseObject];
        BOOL status = NO;
        NSDictionary *contentDic = nil;
        if([content[@"code"] intValue] == 200){
            status = YES;
            contentDic = content[@"message"];
        }else{
            contentDic = @{@"msg":content[@"msg"]};
        }
        if (compate) {
            compate(contentDic,status);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData * responseObject = [[NSData alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"]];
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments
                                                                  error:nil];
        if([content[@"errno"] count] > 0){
            if(compate){
                compate(content[@"message"],NO);
            }
        }else if(error.code == -1001){
            if (compate) {
                compate(@{@"data":@"连接超时"},NO);
            }
        }else if (error.code == -1009){
            if (compate) {
                compate(@"网络断开",NO);
            }
        }else{
            if (compate) {
                compate(@{@"data":@"服务器连接失败!"},NO);
            }
        }
    }];
}




//Url 转码
+ (NSString *)encodeToPercentEscapeString: (NSString *) input withYAY:(BOOL)isYAY{
    CFStringRef  outputStr  = CFBridgingRetain((__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                                            NULL, /* allocator */
                                                                                                            (__bridge CFStringRef)input,
                                                                                                            NULL, /* charactersToLeaveUnescaped */
                                                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                            kCFStringEncodingUTF8));
    NSString *baseString = [NSString stringWithString:(__bridge NSString *)outputStr];
    CFRelease(outputStr);
    return baseString;

}
//- url解码
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    
    NSString *srcString = [input stringByRemovingPercentEncoding];
    return srcString;
}



/**
  字典转JSON
 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
    return jsonString;
    
}


/**
 json字符串转字典

 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 json字符串转数组
 
 */
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
    
}


+ (NSString *)toJSONString:(NSArray *)array {
    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

@end
