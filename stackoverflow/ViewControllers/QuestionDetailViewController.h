//
//  QuestionDetailViewController.h
//  stackoverflow
//
//  Created by Ivan on 08/10/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Alert.h"
#import "QuestionItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionDetailViewController : UIViewController
@property(strong, nonatomic) QuestionItem *question;
@end

NS_ASSUME_NONNULL_END
