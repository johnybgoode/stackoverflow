//
//  User.h
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserEntity;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property(assign, nonatomic) NSInteger accept_rate;
@property(assign, nonatomic) NSInteger user_id;
@property(strong, nonatomic) NSString *user_type;
@property(strong, nonatomic) NSString *link;
@property(strong, nonatomic) NSString *display_name;
@property(assign, nonatomic) NSInteger reputation;
@property(strong, nonatomic) NSString *profile_image;

@end

@interface User (NetworkMapping)

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end


@interface User (CoreData)

- (instancetype)initWithManagedObject:(UserEntity *)entity;
- (UserEntity *)addToManagedObjectContext:(NSManagedObjectContext *)context;

@end


NS_ASSUME_NONNULL_END
