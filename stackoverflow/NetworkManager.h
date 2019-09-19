//
//  NetworkManager.h
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject
@property(strong, atomic) NSString* urlString;
+ (instancetype) sharedSource;
- (void) getQuestions:(void (^)(NSArray *items))successBlock  Error:(void (^)(NSString *errorMessage))errorBlock;
@end

NS_ASSUME_NONNULL_END
