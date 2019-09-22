//
//  UIViewControllerExtension.h
//  MDRMobile
//
//  Created by Ivan Ladenkov on 14.09.17.
//  Copyright © 2018 ase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AlertExtension)
- (void) showAlertWithTitle:(NSString *)title andMessage:(NSString*)message;
- (void) showAlertWithTitle:(NSString *)title andMessage:(NSString*)message buttonTitles:(NSArray<NSString *>*)titles andHandler:(void (^)(UIAlertAction * action))handler;
- (void) showAlertWithTitle:(NSString *)title andMessage:(NSString*)message OKTitle:(NSString*)OKString CancelTitle:(NSString*)cancelString OKHandler:(void (^)(UIAlertAction * action))OKHandler cancelHandler:(void (^)(UIAlertAction * action))cancelHandler;
- (void) setBackButton;

@end
