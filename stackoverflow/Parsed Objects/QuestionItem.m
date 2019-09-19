//
//  QuestionItem.m
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import "QuestionItem.h"
#import "User.h"

@implementation QuestionItem
- (id) initWithDictionary:(NSDictionary*)dict{
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
