//
//  NetworkManager.m
//  stackoverflow
//
//  Created by Ivan on 18/09/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

#import "NetworkManager.h"
#import "QuestionItem.h"
#import <CoreData/CoreData.h>

#import "QuestionItemEntity+CoreDataClass.h"
#import "UserEntity+CoreDataClass.h"

@interface NetworkManager ()

@property (strong, atomic) NSString* urlString;

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation NetworkManager

+ (instancetype) sharedSource {

    static NetworkManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (instancetype) init {

    self = [super init];
    
    self.urlString = @"https://api.stackexchange.com/2.2";
    
    return self;
}
- (NSManagedObjectModel *)managedObjectModel
{
    if( _managedObjectModel!=nil){
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)coordinator
{
    if(nil != _coordinator)
        return _coordinator;
    
    NSURL *storeURL = [[[[NSFileManager defaultManager]
                         URLsForDirectory:NSDocumentDirectory
                         inDomains:NSUserDomainMask]
                        lastObject]
                       URLByAppendingPathComponent:@"stackoverflow.sqlite"];
    
    _coordinator = [[NSPersistentStoreCoordinator alloc]
                    initWithManagedObjectModel:self.managedObjectModel];
    
    NSError *error = nil;
    if(![_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                   configuration:nil
                                             URL:storeURL
                                         options:nil
                                           error:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _coordinator;
}
- (NSManagedObjectContext *)managedObjectContext
{
    if(nil != _managedObjectContext)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator *storeCoordinator = self.coordinator;
    
    if(nil != storeCoordinator){
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:storeCoordinator];
    }
    
    return _managedObjectContext;
}

-  (void) get:(NSString*)params andUrl:(NSString*)subUrl
      success:(void (^)(NSDictionary *response))successBlock
        error:(void (^)(NSString *errorMessage))errorBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@?%@", self.urlString, subUrl, params] ;
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    // [urlRequest setHTTPBody:[sendStr dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setTimeoutInterval:60.0];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * resp  = (NSHTTPURLResponse*)response;
        NSInteger statusCode = resp.statusCode;
        NSLog(@"statusCode: %i", (int)statusCode);
       NSDictionary *dJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //NSString *dJSON =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response: %@", dJSON);
        if ((error == nil)&&(statusCode==200)) {
            
                successBlock(dJSON);
            }
        else {
            errorBlock([self errorMessageWithStatusCode:statusCode]);
        }
    }];
    [getDataTask resume];
}

- (NSString *) errorMessageWithStatusCode:(NSInteger)statusCode{
    
    switch (statusCode) {
        case 400:{
            return @"Неверный запрос";
            break;
        }
        case 401:{
            return @"Ошибка авторизации";
            break;
        }
        case 403:{
            return @"Доступ запрещен";
            break;
        }
        case 404:{
            return @"Данный адрес не найден";
            break;
        }
        case 500:{
            return @"Ошибка внешнего сервера";
            break;
        }
        case 502:{
            return @"Ошибка сервера";
            break;
        }
        default:{
            return @"Неизвестная ошибка";
            break;
        }
    }
}

- (void)loadQuestionsWithSourceType:(enum DataSourceType)sourceType
                         withFilter:(QuestionItemsFilter *)filter
                            success:(void (^)(NSArray *items))successBlock
                            failure:(void (^)(NSString *errorMessage))errorBlock  {
    switch (sourceType) {
        case kDataSourceTypeCache:{
            NSArray <QuestionItem *> *cachedItems = [self loadQuestionsFromCacheWithFilter:filter];
            if (cachedItems && cachedItems.count > 0) {
                
                NSArray <QuestionItem *> *filteredItems = [cachedItems filteredArrayUsingPredicate:[filter filtrationPredicate]];
                successBlock(filteredItems);
                return;
                break;
            }
            else{
                
            }
        }
        case kDataSourceTypeNetwork:{
            [self loadQuestionsFromNetwork:^(NSArray<QuestionItem *> *loadedItems) {
                
                [self saveQuestionsToCache:loadedItems];
                
                NSArray <QuestionItem *> *filteredItems = [loadedItems filteredArrayUsingPredicate:[filter filtrationPredicate]];
                successBlock(filteredItems);
                
            } onFailure:^(NSString *errorText) {
                
                errorBlock(errorText);
            }];
        }
        default:
            break;
    }
       
}


- (void)saveQuestionsToCache:(NSArray <QuestionItem *> *)questionItems {

    for (QuestionItem *item in questionItems) {
        [item addToManagedObjectContext:self.managedObjectContext];
    }

    if (![self.managedObjectContext hasChanges]) {
        return;
    }

    NSError *savingError = nil;
    if (![self.managedObjectContext save:&savingError]) {

        NSAssert(!savingError, @"Core Data saving Error %@", savingError);
        return;
    }
}

- (NSArray <QuestionItem *> *)loadQuestionsFromCacheWithFilter:(QuestionItemsFilter *)filter {

    NSFetchRequest <QuestionItemEntity *> *request = [QuestionItemEntity fetchRequest];

    NSError *fetchingError = nil;
    NSArray <QuestionItemEntity *> *entities = [self.managedObjectContext executeFetchRequest:request
                                                                                        error:&fetchingError];

    if (fetchingError) {
        return nil;
    }

    NSMutableArray <QuestionItem *> *items = [NSMutableArray array];
    for (QuestionItemEntity *entity in entities) {

        QuestionItem *item = [[QuestionItem alloc] initWithManagedObject:entity];
        [items addObject:item];
    }
    return items;
}

- (void)loadQuestionsFromNetwork:(void (^)(NSArray <QuestionItem *> *))successCompletion
                       onFailure:(void (^)(NSString *))failureCompletion {

    NSString *subUrl = @"/questions";
    NSInteger fromDate = [[NSDate date] timeIntervalSince1970]-7*24*60*60;
    NSInteger toDate = [[NSDate date] timeIntervalSince1970];
    NSString *prs = [NSString stringWithFormat:@"sort=%@&min=%i&fromdate=%li&todate=%li&site=%@",@"votes", 10, fromDate, toDate, @"stackoverflow"];

    [self get:prs andUrl:subUrl success:^(NSDictionary *response) {

        NSMutableArray <QuestionItem *> *questionItems = [NSMutableArray array];
        for(NSDictionary *dict in response[@"items"]){

            QuestionItem *mappedItem = [[QuestionItem alloc] initWithDictionary:dict];
            [questionItems addObject:mappedItem];
        }
        successCompletion(questionItems);

    } error:^(NSString *errorMessage) {
        failureCompletion(errorMessage);
    }];
}
- (void) loadQuestionAnswersForQuestionId:(NSInteger)questionId
                      onSuccess:(void (^)(NSArray * answers))successCompletion
                       onFailure:(void (^)(NSString * errorString))failureCompletion {
    
    NSString *subUrl = [NSString stringWithFormat:@"/questions/{%li}/answers", questionId];
   
    NSString *prs = [NSString stringWithFormat:@"sort=%@&order=%@&site=%@",@"votes", @"desc", @"stackoverflow"];
    
    [self get:prs andUrl:subUrl success:^(NSDictionary *response) {
        
        NSMutableArray <QuestionItem *> *questionItems = [NSMutableArray array];
        for(NSDictionary *dict in response[@"items"]){
            
            QuestionItem *mappedItem = [[QuestionItem alloc] initWithDictionary:dict];
            [questionItems addObject:mappedItem];
        }
        successCompletion(questionItems);
        
    } error:^(NSString *errorMessage) {
        failureCompletion(errorMessage);
    }];
}
- (void)clearCoreData {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuestionItemEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Отсутствуют объекты для удаления");
    }
    
    for (QuestionItemEntity *currentObject in fetchedObjects) {
        [self.managedObjectContext deleteObject:currentObject];
    }
    
    entity = [NSEntityDescription entityForName:@"UserEntity" inManagedObjectContext:self.managedObjectContext];
     [fetchRequest setEntity:entity];
    error = nil;
    fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Отсутствуют объекты для удаления");
    }
    
    for (UserEntity *currentObject in fetchedObjects) {
        [self.managedObjectContext deleteObject:currentObject];
    }
    
    [self saveContext];
    
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"Saving didn't work so well.. Error: %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
