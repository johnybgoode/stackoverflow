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


@interface MainViewController ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableDictionary <NSNumber*, NSOperation *> *imageOperations;
@property (nonatomic, strong) NSMutableDictionary <NSNumber*, UIImage *> *images;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *questions;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.operationQueue = [[NSOperationQueue alloc] init];
    self.imageOperations = [[NSMutableDictionary alloc] init];
    self.images = [[NSMutableDictionary alloc] init];

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

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    __weak QuestionTableViewCell *questionCell = (QuestionTableViewCell *)cell;

    questionCell.user_pic_imv.image = nil;
    [self loadImageByIndex:indexPath.row completion:^(UIImage *loadedImage) {
        questionCell.user_pic_imv.image = loadedImage;
    }];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    [self cancelImageLoadingByIndex:indexPath.row];
}

- (void)loadImageByIndex:(NSInteger)imageIndex completion:(void (^)(UIImage *))completion {

    NSMutableDictionary <NSNumber *, NSOperation *> *imageOperations = self.imageOperations;
    NSMutableDictionary <NSNumber *, UIImage *> *images = self.images;

    //Cache
    UIImage *existImage = images[@(imageIndex)];
    if (existImage != nil) {

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(existImage);
        });
        return;
    }

    //Prevent operation duplicates when fast scrolling
    NSOperation *existOperation = imageOperations[@(imageIndex)];
    if (existOperation != nil && !existOperation.isCancelled) {
        return;
    }


    QuestionItem *questionItem = self.questions[imageIndex];
    NSOperation *imageOperation = [NSBlockOperation blockOperationWithBlock:^{

        NSURL *imageURL = [NSURL URLWithString:questionItem.owner.profile_image];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: imageURL];

        if (imageData == nil) {

            dispatch_async(dispatch_get_main_queue(), ^{
                imageOperations[@(imageIndex)] = nil;
            });
            return;
        }
        UIImage *loadedImage = [UIImage imageWithData: imageData];

        dispatch_async(dispatch_get_main_queue(), ^{

            imageOperations[@(imageIndex)] = nil;
            images[@(imageIndex)] = loadedImage;
            completion(loadedImage);
        });
    }];


    imageOperations[@(imageIndex)] = imageOperation;
    [self.operationQueue addOperation:imageOperation];
}
- (void)cancelImageLoadingByIndex:(NSInteger)imageIndex  {

    NSOperation *previousOperation = self.imageOperations[@(imageIndex)];
    [previousOperation cancel];

    self.imageOperations[@(imageIndex)] = nil;
}

/*- (void)loadImageByIndex:(NSNumber *)imageIndexNumber {

    QuestionItem *questionItem = self.questions[imageIndexNumber.integerValue];
    NSURL *imageURL = [NSURL URLWithString:questionItem.owner.profile_image];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: imageURL];

    if (imageData == nil) {

        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageOperations[imageIndexNumber] = nil;
        });
        return;
    }
    UIImage *loadedImage = [UIImage imageWithData: imageData];

    dispatch_sync(dispatch_get_main_queue(), ^{

        self.imageOperations[imageIndexNumber] = nil;
        self.images[imageIndexNumber] = loadedImage;
    });
}*/

- (void) initCell:(QuestionTableViewCell*)qtc withQuestionItem:(QuestionItem*)qi{
    
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
