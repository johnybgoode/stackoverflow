//
//  QuestionItemsFilter.m
//  stackoverflow
//
//  Created by Ivan on 30/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import "QuestionItemsFilter.h"

#import "QuestionItemEntity+CoreDataClass.h"
#import "UserEntity+CoreDataClass.h"

#import "QuestionItem.h"

@implementation QuestionItemsFilter

+ (instancetype)filterBySearchQuery:(NSString *)searchQuery {

    QuestionItemsFilter *filter = [[QuestionItemsFilter alloc] init];

    filter.userName = searchQuery;
    filter.selectedTag = searchQuery;
    filter.questionName = searchQuery;

    return filter;
}

- (NSPredicate *)filtrationPredicate {

    return [NSCompoundPredicate orPredicateWithSubpredicates:@[
        [self predicateByUserName],
        [self predicateBySelectedTag],
        [self predicateByQuestion]
    ]];
}

- (NSPredicate *)predicateByUserName {

    if (!self.userName) {
        return [NSPredicate predicateWithValue:YES];
    }
    return [NSPredicate predicateWithFormat:@"owner.display_name CONTAINS %@", self.userName];
}

- (NSPredicate *)predicateBySelectedTag {

    if (!self.selectedTag) {
        return [NSPredicate predicateWithValue:YES];
    }
    return [NSPredicate predicateWithBlock:
        ^BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *, id> * _Nullable bindings){

            if ([evaluatedObject isKindOfClass:[QuestionItemEntity class]]) {
                QuestionItemEntity *entity = (QuestionItemEntity *)evaluatedObject;

                NSArray<NSString *> *tagsString = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                                                    fromData:entity.tags
                                                                                       error:nil];
                return [tagsString containsObject:self.selectedTag];
            }
            if ([evaluatedObject isKindOfClass:[QuestionItem class]]) {
                QuestionItem *item = (QuestionItem *)evaluatedObject;

                return [item.tags containsObject:self.selectedTag];
            }
            return YES;
        }
    ];
}

- (NSPredicate *)predicateByQuestion {

    if (!self.questionName) {
        return [NSPredicate predicateWithValue:YES];
    }
    return [NSPredicate predicateWithFormat:@"title CONTAINS %@", self.questionName];
}


@end
