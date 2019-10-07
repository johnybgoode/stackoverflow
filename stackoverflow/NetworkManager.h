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

    kDataSourceTypeCache,
    kDataSourceTypeNetwork,
    kDataSourceTypeAllSources
};

@interface NetworkManager : NSObject

+ (instancetype) sharedSource;

- (void)loadQuestionsWithSourceType:(enum DataSourceType)sourceType
                         withFilter:(QuestionItemsFilter *)filter
                            success:(void (^)(NSArray *items))successBlock
                            failure:(void (^)(NSString *errorMessage))errorBlock;

@end

NS_ASSUME_NONNULL_END

