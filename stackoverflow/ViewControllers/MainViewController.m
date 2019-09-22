//
//  ViewController.m
//  stackoverflow
//
//  Created by Ivan on 16/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import "MainViewController.h"
#import "NetworkManager.h"
#import "UIViewController+Alert.h"
#import "QuestionTableViewCell.h"
#import "QuestionItem.h"
#import "TagCollectionViewCell.h"

@interface MainViewController (){
    
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [[NetworkManager sharedSource] getQuestions:^(NSArray * _Nonnull items) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.questions = items;
            [self.tableView reloadData];
        });
    } Error:^(NSString * _Nonnull errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlertWithTitle:@"Ошибка" andMessage:errorMessage];
        });
    }];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.questions count];
}
- (nonnull QuestionTableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    QuestionTableViewCell *cell  = (QuestionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    QuestionItem * qi = self.questions[indexPath.row];
    cell.tags_collection_view.tag = indexPath.row;
    [self initCell:cell withQuestionItem:qi];
    
    return cell;
}
- (void) initCell:(QuestionTableViewCell*)qtc withQuestionItem:(QuestionItem*)qi{
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:qi.owner.profile_image]];
        if ( data == nil ){
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            qtc.imageView.image = [UIImage imageWithData: data];
        });
    });
    qtc.user_name_lbl.text = qi.owner.display_name;
    qtc.question_title_lbl.text = qi.title;
    qtc.tags_collection_view.dataSource = self;
    qtc.tags_collection_view.delegate = self;
    [qtc.tags_collection_view reloadData];
}
- (NSInteger) numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    QuestionItem * qi =  self.questions[collectionView.tag];
    NSUInteger tags_cnt = [qi.tags count];
    return tags_cnt;
}
- (TagCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QuestionItem * qi =  self.questions[collectionView.tag];
    TagCollectionViewCell *cell = (TagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"tagCell" forIndexPath:indexPath];
    cell.tag_title_label.text = qi.tags[indexPath.row];
    // cell customization
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(100.f, 40.f);
}










@end
