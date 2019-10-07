//
//  QuestionItem.m
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import "QuestionItem.h"
#import "User.h"

#import <CoreData/CoreData.h>


@implementation QuestionItem
@end

@implementation QuestionItem (NetworkMapping)

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];

    _answer_count = [dict[@"answer_count"] integerValue];
    _last_edit_date = [dict[@"last_edit_date "] integerValue];
    _owner = [[User alloc] initWithDictionary:dict[@"owner"]];
    _link = dict[@"link"];
    _tags = dict[@"tags"];
    _view_count = [dict[@"view_count"] integerValue];
    _creation_date = [dict[@"creation_date"] integerValue];
    _is_answered = [dict[@"is_answered"] boolValue];
    _title = dict[@"title"];
    _accepted_answer_id = [dict[@"accepted_answer_id"] integerValue];
    _last_activity_date = [dict[@"last_activity_date"] integerValue];
    _question_id = [dict[@"question_id"] integerValue];
    _score = [dict[@"score"] integerValue];

    return self;
}

@end

#import "QuestionItemEntity+CoreDataClass.h"

@implementation QuestionItem (CoreData)

- (instancetype)initWithManagedObject:(QuestionItemEntity *)entity {
    self = [super init];

    self.answer_count = entity.answer_count;
    self.last_edit_date = entity.last_edit_date;
    self.link = entity.link;
    self.view_count = entity.view_count;
    self.creation_date = entity.creation_date;
    self.is_answered = entity.isAnswered;
    self.title = entity.title;
    self.accepted_answer_id = entity.accepted_answer_id;
    self.last_activity_date = entity.last_activity_date;
    self.question_id = entity.question_id;
    self.score = entity.score;

    self.owner = [[User alloc] initWithManagedObject:entity.owner];
    self.tags = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class]
                                                  fromData:entity.tags
                                                     error:nil];

    return self;
}

- (void)addToManagedObjectContext:(NSManagedObjectContext *)context {

    QuestionItemEntity *entity = [[QuestionItemEntity alloc] initWithContext:context];

    entity.answer_count = self.answer_count;
    entity.last_edit_date = self.last_edit_date;
    entity.link = self.link;
    entity.view_count = self.view_count;
    entity.creation_date = self.creation_date;
    entity.isAnswered = self.is_answered;
    entity.title = self.title;
    entity.accepted_answer_id = self.accepted_answer_id;
    entity.last_activity_date = self.last_activity_date;
    entity.question_id = self.question_id;
    entity.score = self.score;

    entity.owner = [self.owner addToManagedObjectContext:context];

    entity.tags = [NSKeyedArchiver archivedDataWithRootObject:self.tags
                                        requiringSecureCoding:NO
                                                        error:nil];
}

@end


