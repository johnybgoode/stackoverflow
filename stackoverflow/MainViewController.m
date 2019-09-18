//
//  ViewController.m
//  stackoverflow
//
//  Created by Ivan on 16/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import "MainViewController.h"
#import "NetworkManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [[NetworkManager sharedSource] getQuestions:^(NSDictionary * _Nonnull data) {
        
    } Error:^(NSString * _Nonnull errorMessage) {
        
    }];
    // Do any additional setup after loading the view.
}


@end
