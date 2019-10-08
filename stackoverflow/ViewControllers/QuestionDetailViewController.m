//
//  QuestionDetailViewController.m
//  stackoverflow
//
//  Created by Ivan on 08/10/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "NetworkManager.h"

@interface QuestionDetailViewController ()

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NetworkManager sharedSource] loadQuestionAnswersForQuestionId:_question.question_id onSuccess:^(NSArray * _Nonnull array) {
        
    } onFailure:^(NSString * _Nonnull string) {
        
    }];
    // Do any additional setup after loading the view.
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
