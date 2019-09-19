//
//  User.m
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import "User.h"

@implementation User
- (id) initWithDictionary:(NSDictionary*)dict{
     _accept_rate = [dict[@"accept_rate"] integerValue];
    _user_id = [dict[@"user_id"] integerValue];
    _user_type =  dict[@"user_type"];
    _link = dict[@"link"] ;
    _display_name =  dict[@"display_name"];
    _reputation = [dict[@"reputation"] integerValue];
    _profile_image = dict[@"profile_image"];
    return self;
}
@end
