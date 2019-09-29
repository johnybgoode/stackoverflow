//
//  User.m
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic accept_rate;
@dynamic user_id;
@dynamic user_type;
@dynamic link;
@dynamic display_name;
@dynamic reputation;
@dynamic profile_image;
- (id) initWithDictionary:(NSDictionary*)dict{
    self.accept_rate = [dict[@"accept_rate"] integerValue];
    self.user_id = [dict[@"user_id"] integerValue];
    self.user_type =  dict[@"user_type"];
    self.link = dict[@"link"] ;
    self.display_name =  dict[@"display_name"];
    self.reputation = [dict[@"reputation"] integerValue];
    self.profile_image = dict[@"profile_image"];
    return self;
}


@end
