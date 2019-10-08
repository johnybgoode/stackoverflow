//
//  NetworkManager.h
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "QuestionItemsFilter.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DataSourceType) {

    kDataSourceTypeCache = 0,
    kDataSourceTypeNetwork = 1
};

@interface NetworkManager : NSObject

+ (instancetype) sharedSource;

- (void)loadQuestionsWithSourceType:(enum DataSourceType)sourceType
                         withFilter:(QuestionItemsFilter *)filter
                            success:(void (^)(NSArray *items))successBlock
                            failure:(void (^)(NSString *errorMessage))errorBlock;
- (void) loadQuestionAnswersForQuestionId:(NSInteger)questionId
                                onSuccess:(void (^)(NSArray * answers))successCompletion
                                onFailure:(void (^)(NSString * errorString))failureCompletion;
- (void)clearCoreData;

@end

NS_ASSUME_NONNULL_END

