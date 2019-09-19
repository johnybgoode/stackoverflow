//
//  User.h
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property(assign, nonatomic) NSInteger accept_rate;
@property(assign, nonatomic) NSInteger user_id;
@property(strong, nonatomic) NSString *user_type;
@property(strong, nonatomic) NSString *link;
@property(strong, nonatomic) NSString *display_name;
@property(assign, nonatomic) NSInteger reputation;
@property(strong, nonatomic) NSString *profile_image;
- (id) initWithDictionary:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
