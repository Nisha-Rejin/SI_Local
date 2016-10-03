//
//  SICoreDataHelper.m
//  Selling Intelligence
//
//  Created by Sailesh on 23/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SICoreDataHandler.h"
#import "Selling_IntelligenceConstants.h"


@interface SICoreDataHandler(PRIVATE)

- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSString *)applicationDocumentsDirectory;

@end

@implementation SICoreDataHandler


static SICoreDataHandler *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (SICoreDataHandler *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


- (NSArray *)recursivePathsForResourcesOfType:(NSString *)type inDirectory:(NSString *)directoryPath{
    
    NSMutableArray *filePaths = [[NSMutableArray alloc] init];
    
    // Enumerators are recursive
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:directoryPath];
    
    NSString *filePath;
    
    while ((filePath = [enumerator nextObject]) != nil){
        // If we have the right type of file, add it to the list
        // Make sure to prepend the directory path
        if([[filePath pathExtension] isEqualToString:type]){
            [filePaths addObject:[directoryPath stringByAppendingString:filePath]];
        }
    }
    
    return filePaths;
}


- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    NSMutableArray *allManagedObjectModels = [[NSMutableArray alloc] init];
    NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:kSIBundle];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    
    NSURL *staticLibraryMOMURL = [frameworkBundle URLForResource:@"SellingIntelligence" withExtension:@"momd"];
    NSManagedObjectModel *staticLibraryMOM = [[NSManagedObjectModel alloc] initWithContentsOfURL:staticLibraryMOMURL];
    [allManagedObjectModels addObject:staticLibraryMOM];
    
    managedObjectModel = [NSManagedObjectModel modelByMergingModels:allManagedObjectModels];
    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"SellingIntelligence.sqlite"];

    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error])
    {
        NSLog(@"Errorrrr---------",error);
        abort();
    }
    
    return persistentStoreCoordinator;
}


-(void)clearAlertsCoreData{
    
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"SellingIntelligence.sqlite"];
    
    NSError *error = nil;
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    
    NSPersistentStore *store = [persistentStoreCoordinator persistentStoreForURL:storeUrl];

    [persistentStoreCoordinator removePersistentStore:store error:&error];
    
    [[NSFileManager defaultManager] removeItemAtPath:storePath error:&error];
    
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
        DebugLog(@"%@ object deleted",entityDescription);
    }
    if (![managedObjectContext save:&error]) {
        DebugLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}


- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end
