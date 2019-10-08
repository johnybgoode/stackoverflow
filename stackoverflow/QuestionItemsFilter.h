//
//  QuestionItemsFilter.h
//  stackoverflow
//
//  Created by Ivan on 30/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QuestionItemsFilter : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *selectedTag; 
@property (nonatomic, strong) NSString *questionName;

+ (instancetype)filterBySearchQuery:(NSString *)searchQuery;

- (NSPredicate *)filtrationPredicate;

@end
