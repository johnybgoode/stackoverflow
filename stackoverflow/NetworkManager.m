//
//  NetworkManager.m
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import "NetworkManager.h"
#import "QuestionItem.h"

@implementation NetworkManager
static NetworkManager * _Instance;
+ (instancetype) sharedSource
{
    
    if (!_Instance) {
        _Instance = [[self alloc] init];
    }
    return _Instance;
}
- (id) init{
    
    self.urlString = @"https://api.stackexchange.com/2.2";
    
    return self;
}
-  (void) get:(NSString*)params andUrl:(NSString*)subUrl
      success:(void (^)(NSDictionary *response))successBlock
        error:(void (^)(NSString *errorMessage))errorBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@?%@", self.urlString, subUrl, params] ;
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    // [urlRequest setHTTPBody:[sendStr dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setTimeoutInterval:60.0];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * resp  = (NSHTTPURLResponse*)response;
        NSInteger statusCode = resp.statusCode;
        NSLog(@"statusCode: %i", (int)statusCode);
       NSDictionary *dJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //NSString *dJSON =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response: %@", dJSON);
        if ((error == nil)&&(statusCode==200)) {
            
                successBlock(dJSON);
            }
        else {
            errorBlock([self errorMessageWithStatusCode:statusCode]);
        }
    }];
    [getDataTask resume];
}
- (NSString *) errorMessageWithStatusCode:(NSInteger)statusCode{
    
    switch (statusCode) {
        case 400:{
            return @"Неверный запрос";
            break;
        }
        case 401:{
            return @"Ошибка авторизации";
            break;
        }
        case 403:{
            return @"Доступ запрещен";
            break;
        }
        case 404:{
            return @"Данный адрес не найден";
            break;
        }
        case 500:{
            return @"Ошибка внешнего сервера";
            break;
        }
        case 502:{
            return @"Ошибка сервера";
            break;
        }
        default:{
            return @"Неизвестная ошибка";
            break;
        }
    }
}
- (void) getQuestions:(void (^)(NSArray *items))successBlock  Error:(void (^)(NSString *errorMessage))errorBlock{
    NSString *subUrl = @"/questions";
    NSInteger fromDate = [[NSDate date] timeIntervalSince1970]-24*60*60;
    NSInteger toDate = [[NSDate date] timeIntervalSince1970];
    NSString *prs = [NSString stringWithFormat:@"sort=%@&min=%i&fromdate=%li&todate=%li&site=%@",@"votes", 10, fromDate, toDate, @"stackoverflow"];
    
    [self get:prs andUrl:subUrl success:^(NSDictionary *response) {
        NSMutableArray * questionItems = [NSMutableArray array];
        for(NSDictionary *dict in response[@"items"]){
            QuestionItem *qi = [[QuestionItem alloc] initWithDictionary:dict];
            [questionItems addObject:qi];
        }
        successBlock(questionItems);
    } error:^(NSString *errorMessage) {
        errorBlock(errorMessage);
    }];
    
    
}
@end
