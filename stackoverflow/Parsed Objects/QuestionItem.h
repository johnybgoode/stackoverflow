//
//  QuestionItem.h
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionItem : NSObject<NSCoding>
@property(assign, nonatomic) NSInteger answer_count;
@property(assign, nonatomic) NSInteger last_edit_date;
@property(strong, nonatomic) User* owner;
@property(strong, nonatomic) NSString *link;
@property(strong, nonatomic) NSArray<NSString*> *tags;
@property(assign, nonatomic) NSInteger view_count;
@property(assign, nonatomic) NSInteger creation_date;
@property(assign, nonatomic) BOOL is_answered;
@property(strong, nonatomic) NSString*  title;
@property(assign, nonatomic) NSInteger accepted_answer_id;
@property(assign, nonatomic) NSInteger last_activity_date;
@property(assign, nonatomic) NSInteger question_id;
@property(assign, nonatomic) NSInteger score;
- (id) initWithDictionary:(NSDictionary*)dict;
@end


NS_ASSUME_NONNULL_END
