//
//  User.m
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import "User.h"
#import <CoreData/CoreData.h>

@implementation User
@end

@implementation User (NetworkMapping)

- (instancetype)initWithDictionary:(NSDictionary *)dict{

    self = [super init];

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


#import "UserEntity+CoreDataClass.h"

@implementation User (CoreData)

- (instancetype)initWithManagedObject:(UserEntity *)entity {

    self = [super init];

    self.accept_rate = entity.accept_rate;
    self.user_id = entity.user_id;
    self.user_type = entity.user_type;
    self.link = entity.link;
    self.display_name = entity.display_name;
    self.reputation = entity.reputation;
    self.profile_image = entity.profile_image;

    return self;
}
- (UserEntity *)addToManagedObjectContext:(NSManagedObjectContext *)context {

    UserEntity *entity = [[UserEntity alloc] initWithContext:context];

    entity.accept_rate = self.accept_rate;
    entity.user_id = self.user_id;
    entity.user_type = self.user_type;
    entity.link = self.link;
    entity.display_name = self.display_name;
    entity.reputation = self.reputation;
    entity.profile_image = self.profile_image;

    return entity;
}

@end
