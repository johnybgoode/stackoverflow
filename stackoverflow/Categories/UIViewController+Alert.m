//
//  UIViewControllerExtension.m
//  MDRMobile
//
//  Created by Ivan Ladenkov on 14.09.17.
//  Copyright © 2018 ase. All rights reserved.
//

#import "UIViewController+Alert.h"


@implementation UIViewController (AlertExtension)
- (void) showAlertWithTitle:(NSString *)title andMessage:(NSString*)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:nil];
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void) showAlertWithTitle:(NSString *)title andMessage:(NSString*)message buttonTitles:(NSArray<NSString *>*)titles andHandler:(void (^)(UIAlertAction * action))handler  {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:titles[0]
                                style:UIAlertActionStyleDefault
                                handler:handler];
    [alert addAction:yesButton];
    if([titles count]!=1){
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:titles[1]
                                       style:UIAlertActionStyleDefault
                                       handler:nil];
        
        [alert addAction:cancelButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) showAlertWithTitle:(NSString *)title andMessage:(NSString*)message OKTitle:(NSString*)OKString CancelTitle:(NSString*)cancelString OKHandler:(void (^)(UIAlertAction * action))OKHandler cancelHandler:(void (^)(UIAlertAction * action))cancelHandler {
    UIAlertController * alert =   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:OKString
                                style:UIAlertActionStyleDefault
                                handler:OKHandler];
    [alert addAction:yesButton];
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:cancelString
                                       style:UIAlertActionStyleDefault
                                       handler:cancelHandler];
        
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) setBackButton{
    UIButton* someButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [someButton setFrame:CGRectMake(0, 0, 25, 25)];
    [someButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem* someBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    [someButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:someBarButtonItem];
}
- (void) backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
