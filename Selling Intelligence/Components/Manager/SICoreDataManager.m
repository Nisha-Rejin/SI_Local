//
//  SICoreDataManager.m
//  Selling Intelligence
//
//  Created by Cognizant MSP on 01/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SICoreDataManager.h"

@implementation SICoreDataManager

static SICoreDataManager* _sharedDBApplication;


+ (SICoreDataManager *)sharedDataManager
{
    if (!_sharedDBApplication)
    {
        _sharedDBApplication = [[SICoreDataManager alloc] init];
        
    }
    return _sharedDBApplication;
}

#pragma mark-Configuration Methods

-(void)insertCustomerConfiguration:(NSDictionary *)configDictionary{
    
    NSError *error;
    NSManagedObjectContext *context = [[SICoreDataHandler sharedInstance] managedObjectContext];
    
    Configuration *config;
    
    config=[self fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    if (config!=nil) {
        
        
        if ([SIUtiliesController checkForNull:[configDictionary objectForKey:kPurePlayOpportunity] forParameter:[NSNumber class]])
            config.isPurePlay=[NSNumber numberWithInt:YES];
        else
            config.isPurePlay=[NSNumber numberWithInt:NO];
        
        if ([SIUtiliesController checkForNull:[configDictionary objectForKey:kSKUVoids] forParameter:[NSNumber class]])
            config.isSKUVoids=[NSNumber numberWithInt:YES];
        else
            config.isSKUVoids=[NSNumber numberWithInt:NO];
        
        
        if ([SIUtiliesController checkForNull:[configDictionary objectForKey:kSKUMissinginPOG] forParameter:[NSNumber class]])
            config.isMissingSKUs=[NSNumber numberWithInt:YES];
        else
            config.isMissingSKUs=[NSNumber numberWithInt:NO];
        
        if ([SIUtiliesController checkForNull:[configDictionary objectForKey:kInnovationOpportunity] forParameter:[NSNumber class]])
            config.isInnovation=[NSNumber numberWithInt:YES];
        else
            config.isInnovation=[NSNumber numberWithInt:NO];
        
        return;
        

    }
    else
    {
    config =[NSEntityDescription insertNewObjectForEntityForName:kConfigurationEntity inManagedObjectContext:context];
        
        
        
        NSString *countryCode=[configDictionary objectForKey:kCountryCode];
        if([SIUtiliesController checkForNull:countryCode forParameter:[NSString class]]) {
            config.countryCode=countryCode;
        }
        else
            config.countryCode=@"";
        
        NSString *versionNo=[configDictionary objectForKey:kVersion];
        if([SIUtiliesController checkForNull:versionNo forParameter:[NSString class]]) {
            config.version=versionNo;
        }
        else
            config.version=@"";
        
        NSString *geoLevelID=[configDictionary objectForKey:kGeoLevelId];
        if([SIUtiliesController checkForNull:geoLevelID forParameter:[NSString class]]) {
            config.geoLevelID=geoLevelID;
        }
        else
            config.geoLevelID=@"";
        
        if ([SIUtiliesController checkForNull:[configDictionary objectForKey:kPurePlayOpportunity] forParameter:[NSNumber class]])
            config.isPurePlay=[NSNumber numberWithInt:YES];
        else
            config.isPurePlay=[NSNumber numberWithInt:NO];
        
        if ([SIUtiliesController checkForNull:[configDictionary objectForKey:kSKUVoids] forParameter:[NSNumber class]])
            config.isSKUVoids=[NSNumber numberWithInt:YES];
        else
            config.isSKUVoids=[NSNumber numberWithInt:NO];
        
        
        if ([SIUtiliesController checkForNull:[configDictionary objectForKey:kSKUMissinginPOG] forParameter:[NSNumber class]])
            config.isMissingSKUs=[NSNumber numberWithInt:YES];
        else
            config.isMissingSKUs=[NSNumber numberWithInt:NO];
        
        if ([SIUtiliesController checkForNull:[configDictionary objectForKey:kInnovationOpportunity] forParameter:[NSNumber class]])
            config.isInnovation=[NSNumber numberWithInt:YES];
        else
            config.isInnovation=[NSNumber numberWithInt:NO];
        
        
        NSString *geolvlTypCde=[configDictionary objectForKey:kGeoLevelTypeCode];
        if([SIUtiliesController checkForNull:geolvlTypCde forParameter:[NSString class]]) {
            config.geoLevelTypeCode=geolvlTypCde;
        }
        else
            config.geoLevelTypeCode=@"";
        
        NSString *srbunum =[configDictionary objectForKey:ksrbuNum];
        if([SIUtiliesController checkForNull:srbunum forParameter:[NSString class]]) {
            config.srbNum=srbunum;
        }
        else
            config.srbNum=@"";
        
        NSNumber *actionedAlertCount =[SIUtiliesController convertStringToNumber:[configDictionary objectForKey:kActionedAlertsCount]];
        if([SIUtiliesController checkForNull:actionedAlertCount forParameter:[NSNumber class]]) {
            config.actionedAlertCount=actionedAlertCount;
        }
        else
            config.actionedAlertCount=0;
        
        NSNumber *unActionedAlertCount =[SIUtiliesController convertStringToNumber:[configDictionary objectForKey:kUnactionedAlertsCount]];
        if([SIUtiliesController checkForNull:unActionedAlertCount forParameter:[NSNumber class]]) {
            config.unActionedAlertCount=unActionedAlertCount;
        }
        else
            config.unActionedAlertCount= 0;
        
        
        NSString *storeID =[SIUtiliesController getStoreID];
        if([SIUtiliesController checkForNull:storeID forParameter:[NSString class]]) {
            config.storeID=storeID;
        }
        else
            config.storeID=@"";
        
        NSString *gpID =[SIUtiliesController getgpID];
        if([SIUtiliesController checkForNull:gpID forParameter:[NSString class]]) {
            config.gpID=gpID;
        }
        else
            config.gpID=@"";
        
        if ([context save:&error])
        {
            DebugLog(@"Configuration saved to DB successfully");
        }
        else
            DebugLog(kFailed);
    }
    
}

-(Configuration *)fetchConfigurationDetailsForstoreID:(NSString *)storeID{
    
    Configuration *config;
    NSError *error;
    NSManagedObjectContext *context=[[SICoreDataHandler sharedInstance] managedObjectContext];
    NSEntityDescription *configEntity=[NSEntityDescription entityForName:kConfigurationEntity inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    [fetchRequest setEntity:configEntity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    if(storeID != nil){
        NSPredicate *Customerpredicate = [NSPredicate predicateWithFormat:@"storeID contains[c] %@",storeID];
        [fetchRequest setPredicate:Customerpredicate];
        
        
        NSArray *tempArray=[context executeFetchRequest:fetchRequest error:&error];
        
        if (tempArray.count>0) {
            
            for (Configuration *configObj in tempArray) {
                config=configObj;
                
            }
        }
        else
        {
            config=nil;
        }

    }else{
        return nil;
    }
    
    return config;
    
}

-(NSMutableDictionary *)getConfigurationDetails{
    
    NSMutableDictionary *configurationDictionary=[NSMutableDictionary dictionary];
    Configuration *configObj=[self fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    

    
    if([SIUtiliesController checkForNull:configObj.countryCode forParameter:[NSString class]])
        [configurationDictionary setObject:configObj.countryCode forKey:kCountryCode];
    else
        [configurationDictionary setObject:@"0" forKey:kCountryCode];
    
    if([SIUtiliesController checkForNull:configObj.geoLevelID forParameter:[NSString class]])
        [configurationDictionary setObject:configObj.geoLevelID forKey:kGeoLevelId];
    else
        [configurationDictionary setObject:@"0" forKey:kGeoLevelId];
    
    if([SIUtiliesController checkForNull:configObj.geoLevelTypeCode forParameter:[NSString class]])
        [configurationDictionary setObject:configObj.geoLevelTypeCode forKey:kGeoLevelTypeCode];
    else
        [configurationDictionary setObject:@"0" forKey:kGeoLevelTypeCode];
    
    if([SIUtiliesController checkForNull:configObj.isInnovation forParameter:[NSNumber class]])
        [configurationDictionary setObject:configObj.isInnovation forKey:kIsInnovation];
    else
        [configurationDictionary setObject:[NSNumber numberWithBool:NO]forKey:kIsInnovation];
    
    if([SIUtiliesController checkForNull:configObj.isMissingSKUs forParameter:[NSNumber class]])
        [configurationDictionary setObject:configObj.isMissingSKUs forKey:kIsMissingSKUs];
    else
        [configurationDictionary setObject:[NSNumber numberWithBool:NO]forKey:kIsMissingSKUs];
    
    if([SIUtiliesController checkForNull:configObj.isSKUVoids forParameter:[NSNumber class]])
        [configurationDictionary setObject:configObj.isSKUVoids forKey:kIsSKUVoids];
    else
        [configurationDictionary setObject:[NSNumber numberWithBool:NO]forKey:kIsSKUVoids];
    
    if([SIUtiliesController checkForNull:configObj.isPurePlay forParameter:[NSNumber class]])
        [configurationDictionary setObject:configObj.isPurePlay forKey:kIsPurePlay];
    else
        [configurationDictionary setObject:[NSNumber numberWithBool:NO]forKey:kIsPurePlay];
    
    
    if([SIUtiliesController checkForNull:configObj.srbNum forParameter:[NSString class]])
        [configurationDictionary setObject:configObj.srbNum forKey:ksrbuNum];
    else
        [configurationDictionary setObject:@"0" forKey:ksrbuNum];
    
    
    if([SIUtiliesController checkForNull:configObj.storeID forParameter:[NSString class]])
        [configurationDictionary setObject:configObj.storeID forKey:kStoreID];
    else
        [configurationDictionary setObject:@"0" forKey:kStoreID];
    
    if([SIUtiliesController checkForNull:configObj.gpID forParameter:[NSString class]])
        [configurationDictionary setObject:configObj.gpID forKey:kGPID];
    else
        [configurationDictionary setObject:@"0" forKey:kGPID];
    
    
    if([SIUtiliesController checkForNull:configObj.actionedAlertCount forParameter:[NSNumber class]])
        [configurationDictionary setObject:configObj.actionedAlertCount forKey:kActionedAlertsCount];
    else
        [configurationDictionary setObject:[NSNumber numberWithInt:0]forKey:kActionedAlertsCount];
    
    if([SIUtiliesController checkForNull:configObj.unActionedAlertCount forParameter:[NSNumber class]])
        [configurationDictionary setObject:configObj.unActionedAlertCount forKey:kUnactionedAlertsCount];
    else
        [configurationDictionary setObject:[NSNumber numberWithInt:0]forKey:kActionedAlertsCount];
    
    
    
    return configurationDictionary;
    
}

#pragma mark - fetch version number from config


#pragma mark-Pureplay Alerts

-(void)insertPurePlayAlerts:(NSArray *)ppAlertsArray forActionedAlerts:(BOOL)isActionedAlert withAlertsInfo:(NSDictionary *)alertInfoDict {
    
    NSError *error;
    NSManagedObjectContext *context = [[SICoreDataHandler sharedInstance] managedObjectContext];
    
    Configuration *configObj=[self fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    if(configObj.isPurePlay){
        for (NSDictionary *purePlayDict in ppAlertsArray) {
            
            
            Pureplay *purePlay = nil;
            purePlay=[self fetchPurePlayForQuestionID:[purePlayDict objectForKey:kQuestionId] andConfiguration:configObj andVersion:[purePlayDict objectForKey:kVersion]];
           


            if (purePlay==nil && [SIUtiliesController checkForNull:[purePlayDict objectForKey:kQuestionId]forParameter:[NSString class]]) {
                
                
                purePlay=[NSEntityDescription insertNewObjectForEntityForName:kPurePlayEntity inManagedObjectContext:context];
                
                if (isActionedAlert) {
                    
                    NSString *actionedDate=[purePlayDict objectForKey:kActionedDate];
                    
                    if (actionedDate!=nil) {
                        purePlay.ppActionedDate=actionedDate;
                    }
                    
                }
                
                NSString *actionedFlag=[purePlayDict objectForKey:kActionedFlag];
                purePlay.ppAction=actionedFlag;
                
                
                NSString *headerId=[purePlayDict objectForKey:kHeaderId];
                if([SIUtiliesController checkForNull:headerId forParameter:[NSString class]]) {
                    purePlay.headerID=headerId;
                }
                else
                    purePlay.headerID=@"";
                
                NSString *imageID=[purePlayDict objectForKey:kImageId];
                if([SIUtiliesController checkForNull:imageID forParameter:[NSString class]]) {
                    purePlay.imageID=imageID;
                }
                else
                    purePlay.imageID=@"";
                
                NSString *version=[purePlayDict objectForKey:kVersion];
                if([SIUtiliesController checkForNull:version forParameter:[NSString class]]) {
                    purePlay.version=version;
                }
                else
                    purePlay.version=@"";
                
                NSString *pureplayName=[purePlayDict objectForKey:kQuestionDescription];
                if([SIUtiliesController checkForNull:pureplayName forParameter:[NSString class]]) {
                    purePlay.pureplayName=pureplayName;
                }
                else
                    purePlay.pureplayName=@"";
                
                
                NSString *defID=[purePlayDict objectForKey:kDefId];
                if([SIUtiliesController checkForNull:defID forParameter:[NSString class]]) {
                    purePlay.defID=defID;
                }
                else
                    purePlay.defID=@"";
                
                NSString *questionID=[purePlayDict objectForKey:kQuestionId];
                if([SIUtiliesController checkForNull:questionID forParameter:[NSString class]]) {
                    purePlay.questionID=questionID;
                }
                else
                    purePlay.questionID=@"";
                
                NSString *alertType=[alertInfoDict objectForKey:kAlertType];
                if([SIUtiliesController checkForNull:alertType forParameter:[NSString class]]) {
                    purePlay.alertType=alertType;
                }
                else
                    purePlay.alertType=@"";
                
                NSString *alertID=[alertInfoDict objectForKey:kAlertID];
                if([SIUtiliesController checkForNull:alertID forParameter:[NSString class]]) {
                    purePlay.alertID=alertID;
                }
                else
                    purePlay.alertID=@"";
                
                NSString *mfoID=[purePlayDict objectForKey:kMfoId];
                if([SIUtiliesController checkForNull:mfoID forParameter:[NSString class]]) {
                    purePlay.mfoId=mfoID;
                }
                else
                    purePlay.mfoId=@"";
                
               
                NSString *gpId=[purePlayDict objectForKey:kGPID];
                if([SIUtiliesController checkForNull:gpId forParameter:[NSString class]]) {
                    purePlay.gpId=gpId;
                }
                else
                    purePlay.gpId=@"";
                
                // insert isYesActionEnabled, isYesActionEnabled -Nisha
                
                
                
                if ([SIUtiliesController checkForNull:[purePlayDict objectForKey:kYesActionEnabled] forParameter:[NSNumber class]])
                    purePlay.isYesActionEnabled=[NSNumber numberWithBool:YES];
                else
                    purePlay.isYesActionEnabled=[NSNumber numberWithBool:NO];
                
                if ([SIUtiliesController checkForNull:[purePlayDict objectForKey:kNoActionEnabled] forParameter:[NSNumber class]])
                purePlay.isNoActionEnabled=[NSNumber numberWithBool:YES];
                else
                    purePlay.isNoActionEnabled=[NSNumber numberWithBool:NO];
                
                ////

                
                [configObj addPurePlayObject:purePlay];
                
                
                if ([context save:&error])
                {
                    DebugLog(@"pureplay saved to DB successfully");
                }
                else
                    DebugLog(kFailed);
            }
            else{
                [self updatePurePlayAlertsForActionType:purePlay withDictionary:purePlayDict];
            }
        }
    }
    
    
}

-(Pureplay *)fetchPurePlayForQuestionID:(NSString *)questionID andConfiguration:(Configuration *)configObj andVersion:(NSString *)version{
    Pureplay *purePlayObj;
    NSArray *ppAlertsArray = [configObj.purePlay allObjects];
    NSPredicate *questionPredicate=[NSPredicate predicateWithFormat:@"questionID==%@",questionID];
    NSPredicate *versionPredicate=[NSPredicate predicateWithFormat:@"version==%@",version];
    NSCompoundPredicate *compoundPredicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[questionPredicate,versionPredicate]];
    
    NSArray *tempArray =[ppAlertsArray filteredArrayUsingPredicate:compoundPredicate];
    if (tempArray.count>0) {
        for (Pureplay *ppObj in tempArray) {
            purePlayObj=ppObj;
        }
        
    }
    else
        purePlayObj=nil;
    return purePlayObj;
    
}

-(void)updatePurePlayAlertsForActionType:(Pureplay *)purePlayObj withDictionary:(NSDictionary *)alertDict {
  
    
            if ([SIUtiliesController checkForNull:[alertDict objectForKey:kVersion] forParameter:[NSString class]]) {
                if ([purePlayObj.version isEqual:[alertDict objectForKey:kVersion]]) {
                    NSString *actionedDate =[alertDict objectForKey:kActionedDate];
                    NSString *gpID =[alertDict objectForKey:kGPID];
                    
                    if ([SIUtiliesController checkForNull:actionedDate forParameter:[NSString class]])
                        purePlayObj.ppActionedDate=actionedDate;
                    
                    if ([SIUtiliesController checkForNull:gpID forParameter:[NSString class]] && ![SIUtiliesController checkForNull:purePlayObj.gpId forParameter:[NSString class]] )
                        purePlayObj.gpId=gpID;
                    
                        [self saveContext];
            }
        }
}


-(NSMutableDictionary *)getPurePlayAlertsForConfiguration:(Configuration *)configObj{
    
    NSArray *alertsArray=[configObj.purePlay allObjects];
    
    NSMutableDictionary *ppAlertsDict,*purePlayDict;
    
    NSMutableArray *actionedAlerts=[NSMutableArray array];
    NSMutableArray *unactionedAlerts=[NSMutableArray array];
    purePlayDict=[NSMutableDictionary dictionary];
    
    for (Pureplay *ppObj in alertsArray) {
        
        ppAlertsDict=[NSMutableDictionary dictionary];
        
        
        NSString *gpId = ppObj.gpId;
        if([SIUtiliesController checkForNull:gpId forParameter:[NSString class]]) {
            [ppAlertsDict setObject:gpId forKey:kGPID];
        }
        else
            [ppAlertsDict setObject:@"" forKey:kGPID];
        
        
        NSString *headerId = ppObj.headerID;
        if([SIUtiliesController checkForNull:headerId forParameter:[NSString class]]) {
            [ppAlertsDict setObject:ppObj.headerID forKey:kHeaderId];
        }
        else
            [ppAlertsDict setObject:@"" forKey:kHeaderId];
        
        NSString *imgId = ppObj.imageID;
        if([SIUtiliesController checkForNull:imgId forParameter:[NSString class]]) {
            [ppAlertsDict setObject:ppObj.imageID forKey:kImageId];
        }
        else
            [ppAlertsDict setObject:@"" forKey:kImageId];
        
        NSString *pureplayName = ppObj.pureplayName;
        if([SIUtiliesController checkForNull:pureplayName forParameter:[NSString class]]) {
            [ppAlertsDict setObject:ppObj.pureplayName forKey:kQuestionDescription];
        }
        else
            [ppAlertsDict setObject:@"" forKey:kQuestionDescription];
        
        NSString *defID = ppObj.defID;
        if([SIUtiliesController checkForNull:defID forParameter:[NSString class]]) {
            [ppAlertsDict setObject:ppObj.defID forKey:kDefId];
        }
        else
            [ppAlertsDict setObject:@"" forKey:kDefId];
        
        NSString *mfoId = ppObj.mfoId;
        if([SIUtiliesController checkForNull:mfoId forParameter:[NSString class]]) {
            [ppAlertsDict setObject:ppObj.mfoId forKey:kMfoId];
        }
        else
            [ppAlertsDict setObject:@"" forKey:kMfoId];
        
        NSString *questionID = ppObj.questionID;
        if([SIUtiliesController checkForNull:questionID forParameter:[NSString class]]) {
            [ppAlertsDict setObject:ppObj.questionID forKey:kQuestionId];
            
        }
        else
            [ppAlertsDict setObject:@"" forKey:kQuestionId];
        
        NSString *version = ppObj.version;
        if([SIUtiliesController checkForNull:version forParameter:[NSString class]]) {
            [ppAlertsDict setObject:version forKey:kVersion];
        }
        else
            [ppAlertsDict setObject:@"" forKey:kVersion];
        
        
        NSString *alertType = ppObj.alertType;
        if([SIUtiliesController checkForNull:alertType forParameter:[NSString class]]) {
            [ppAlertsDict setObject:ppObj.alertType forKey:kAlertType];
            
        }
        else
            [ppAlertsDict setObject:@"" forKey:kAlertType];
        
        NSString *alertID = ppObj.alertID;
        if([SIUtiliesController checkForNull:alertID forParameter:[NSString class]]) {
            [ppAlertsDict setObject:ppObj.alertID forKey:kAlertID];
            
        }
        else
            [ppAlertsDict setObject:@"" forKey:kAlertID];
        
        
        NSString *ppAction = ppObj.ppAction;
        if([SIUtiliesController checkForNull:ppAction forParameter:[NSString class]]) {
            
            if ([ppAction isEqual:kYes] || [ppAction isEqual:kNo]) {
                [ppAlertsDict setObject:ppAction forKey:kActionedFlag];
            }
        }
        
        
        
        NSString *ppAction = ppObj.ppAction;
        if([SIUtiliesController checkForNull:ppAction forParameter:[NSString class]]) {
            
            if ([ppAction isEqual:kYes] || [ppAction isEqual:kNo]) {
                [ppAlertsDict setObject:ppAction forKey:kActionedFlag];
            }
        }

        
        //code by Nisha for get isNoActionEnabled,isYesActionEnabled
        
        if([SIUtiliesController checkForNull:ppObj.isYesActionEnabled forParameter:[NSNumber class]])
            [ppAlertsDict setObject:ppObj.isYesActionEnabled forKey:kYesActionEnabled];
        else
            [ppAlertsDict setObject:[NSNumber numberWithBool:NO]forKey:kYesActionEnabled];
        
        if([SIUtiliesController checkForNull:ppObj.isNoActionEnabled forParameter:[NSNumber class]])
        [ppAlertsDict setObject:ppObj.isNoActionEnabled forKey:kNoActionEnabled];
        else
            [ppAlertsDict setObject:[NSNumber numberWithBool:NO]forKey:kNoActionEnabled];

        ///////////
        
        if (ppObj.ppActionedDate!=nil) {
            [ppAlertsDict setObject:ppObj.ppActionedDate forKey:kActionedDate];
            
            [actionedAlerts addObject:ppAlertsDict];
        }
        else
            [unactionedAlerts addObject:ppAlertsDict];
        
    }
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kQuestionId ascending:YES];
//    
//    
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:
//                                    sortDescriptor,
//                                    nil];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kQuestionDescription ascending:YES];
    
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                sortDescriptor,
                                nil];
    
    NSSortDescriptor *actionedDescriptor=[[NSSortDescriptor alloc] initWithKey:kActionedDate ascending:NO];
    NSSortDescriptor *sortQuestionDescription = [[NSSortDescriptor alloc] initWithKey:kQuestionDescription ascending:YES];
    NSArray *actionedDescriptors=[NSArray arrayWithObjects:actionedDescriptor,sortQuestionDescription, nil];

    
    NSArray * sortedActionedArray = [actionedAlerts sortedArrayUsingDescriptors:actionedDescriptors];

    
    NSArray * sortedUnactionedArray = [unactionedAlerts sortedArrayUsingDescriptors:sortDescriptors];
    

    [purePlayDict setObject:sortedActionedArray forKey:kActioned];
    [purePlayDict setObject:sortedUnactionedArray forKey:kUnActioned];
    
    return purePlayDict;
}

#pragma mark-Sku Voids

-(void)insertSKUVoidsAlerts:(NSArray *)skuAlertsArray forActionedAlerts:(BOOL)isActionedAlert withAlertsInfo:(NSDictionary *)alertInfoDict
{
    NSError *error;
    NSManagedObjectContext *context = [[SICoreDataHandler sharedInstance] managedObjectContext];
    
    
    Configuration *configObj=[self fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    if(configObj.isSKUVoids){
        
        for (NSDictionary *skuAlertsDict in skuAlertsArray) {
            SKUVoids *skuVoids;
            
            skuVoids=[self fetchSKUVoidsForUPCCode:[skuAlertsDict objectForKey:kUPC] andConfiguration:configObj andVersion:[skuAlertsDict objectForKey:kVersion]];
            
            

            
            
            if (skuVoids==nil && [SIUtiliesController checkForNull:[skuAlertsDict objectForKey:kUPC]forParameter:[NSString class]]) {
                
                skuVoids=[NSEntityDescription insertNewObjectForEntityForName:kSKUVoidsEntity inManagedObjectContext:context];
                
                if (isActionedAlert) {
                    
                    NSString *actionedDate =[skuAlertsDict objectForKey:kActionedDate];
                    
                    if (actionedDate!=nil) {
                        skuVoids.skuActionedDate=actionedDate;
                    }
                    
                    
                    
                }
                NSString *actionedFlag=[skuAlertsDict objectForKey:kActionedFlag];
                skuVoids.skuAlertAction=actionedFlag;
                
                NSString *alertType=[alertInfoDict objectForKey:kAlertType];
                if([SIUtiliesController checkForNull:alertType forParameter:[NSString class]]) {
                    skuVoids.alertType=alertType;
                }
                else
                    skuVoids.alertType=@"";
                
                NSString *alertID=[alertInfoDict objectForKey:kAlertID];
                if([SIUtiliesController checkForNull:alertID forParameter:[NSString class]]) {
                    skuVoids.alertID=alertID;
                }
                else
                    skuVoids.alertID=@"";
                
                NSString *upcCode =[skuAlertsDict objectForKey:kUPC];
                if([SIUtiliesController checkForNull:upcCode forParameter:[NSString class]]) {
                    skuVoids.upcCode=upcCode;
                }
                else
                    skuVoids.upcCode=@"";
                
                NSString *altUPCCode =[skuAlertsDict objectForKey:kAltUPC];
                if([SIUtiliesController checkForNull:altUPCCode forParameter:[NSString class]]) {
                    skuVoids.altUPCCode=altUPCCode;
                }
                else
                    skuVoids.altUPCCode=altUPCCode;
                
                NSString *skuName =[skuAlertsDict objectForKey:kSkuName];
                if([SIUtiliesController checkForNull:skuName forParameter:[NSString class]]) {
                    skuVoids.skuName=skuName;
                }
                else
                    skuVoids.skuName=@"";
                
                
                NSString *gpId=[skuAlertsDict objectForKey:kGPID];
                if([SIUtiliesController checkForNull:gpId forParameter:[NSString class]]) {
                    skuVoids.gpId=gpId;
                }
                else
                    skuVoids.gpId=@"";
                
                
                
                NSString *skuVelocity =[skuAlertsDict objectForKey:kSKUVelocity];
                if([SIUtiliesController checkForNull:skuVelocity forParameter:[NSString class]]) {
                    skuVoids.skuVelocity=skuVelocity;
                }
                else
                    skuVoids.skuVelocity=@"";
                
                NSString *skuRank =[skuAlertsDict objectForKey:kSKURank];
                if([SIUtiliesController checkForNull:skuRank forParameter:[NSString class]]) {
                    skuVoids.skuRank=skuRank;
                }
                else
                    skuVoids.skuRank=@"";
                
                NSString *version =[skuAlertsDict objectForKey:kVersion];
                if([SIUtiliesController checkForNull:version forParameter:[NSString class]]) {
                    skuVoids.version=version;
                }
                else
                    skuVoids.version=@"";
                
                NSString *mfoID=[skuAlertsDict objectForKey:kMfoId];

                if([SIUtiliesController checkForNull:mfoID forParameter:[NSString class]]) {
                    skuVoids.mfoId=mfoID;
                }
                else
                    skuVoids.mfoId=@"";
                
                // insert isYesActionEnabled, isYesActionEnabled,invenID - Nisha
                
                if ([SIUtiliesController checkForNull:[skuAlertsDict objectForKey:kYesActionEnabled] forParameter:[NSNumber class]])
                    skuVoids.isYesActionEnabled=[NSNumber numberWithBool:YES];
                else
                    skuVoids.isYesActionEnabled=[NSNumber numberWithBool:NO];
                
                if ([SIUtiliesController checkForNull:[skuAlertsDict objectForKey:kNoActionEnabled] forParameter:[NSNumber class]])
                    skuVoids.isNoActionEnabled=[NSNumber numberWithBool:YES];
                else
                    skuVoids.isNoActionEnabled=[NSNumber numberWithBool:NO];

                NSString *invenID=[skuAlertsDict objectForKey:kinvenID];
                if([SIUtiliesController checkForNull:invenID forParameter:[NSString class]]) {
                    skuVoids.invenID=invenID;
                }
                else
                    skuVoids.invenID=@"";
                ////
                
                [configObj addSkuVoidObject:skuVoids];
                
                if ([context save:&error])
                {
                    DebugLog(@"skuvoids saved to DB successfully");
                }
                else
                    DebugLog(kFailed);
                
                
            }
            else if(skuVoids!=nil){
                [self updateSKUAlertsForActionType:skuVoids withDictionary:skuAlertsDict];
            }
            
        }
    }
    
}

-(SKUVoids *)fetchSKUVoidsForUPCCode:(NSString *)upcCode andConfiguration:(Configuration *)configObj andVersion:(NSString *)version{
    
    SKUVoids *skuVoidsObj;
    
    NSArray *skuAlertsArray = [configObj.skuVoid allObjects];
    NSPredicate *upcPredicate=[NSPredicate predicateWithFormat:@"upcCode==%@",upcCode];
    NSPredicate *versionPredicate=[NSPredicate predicateWithFormat:@"version==%@",version];
    NSCompoundPredicate *compoundPredicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[upcPredicate,versionPredicate]];
    
    NSArray *tempArray =[skuAlertsArray filteredArrayUsingPredicate:compoundPredicate];
    if (tempArray.count>0) {
        
        for (SKUVoids *skuObj in tempArray) {
            skuVoidsObj=skuObj;
        }
    }
    
    else
        skuVoidsObj=nil;
    
    return skuVoidsObj;
}

-(void)updateSKUAlertsForActionType:(SKUVoids *)skuObj withDictionary:(NSDictionary *)alertDict {
    
            if ([SIUtiliesController checkForNull:[alertDict objectForKey:kVersion] forParameter:[NSString class]]) {
                
                if ([skuObj.version isEqual:[alertDict objectForKey:kVersion]]) {
                    NSString *actionedDate =[alertDict objectForKey:kActionedDate];
                    NSString *gpID =[alertDict objectForKey:kGPID];
                    if ([SIUtiliesController checkForNull:actionedDate forParameter:[NSString class]])
                        skuObj.skuActionedDate=actionedDate;
                    
                    if ([SIUtiliesController checkForNull:gpID forParameter:[NSString class]] &&  ![SIUtiliesController checkForNull:skuObj.gpId forParameter:[NSString class]])
                        skuObj.gpId=gpID;
                    
                    [self saveContext];
                   
            }
            
        }
  
}




-(NSMutableDictionary *)getSKUVoidsAlertsForConfiguration:(Configuration *)configObj{
    
    NSArray *alertsArray=[configObj.skuVoid allObjects];
    
    NSMutableDictionary *skuAlertsDict,*skuVoidsDict;
    
    NSMutableArray *actionedAlerts=[NSMutableArray new];
    NSMutableArray *unactionedAlerts=[NSMutableArray new];
    skuVoidsDict=[NSMutableDictionary dictionary];
    
    for (SKUVoids *skuVoidsObj in alertsArray) {
        
        skuAlertsDict=[NSMutableDictionary new];
        
        
        NSString *alertType = skuVoidsObj.alertType;
        if([SIUtiliesController checkForNull:alertType forParameter:[NSString class]]) {
            [skuAlertsDict setObject:skuVoidsObj.alertType forKey:kAlertType];
            
        }
        else
            [skuAlertsDict setObject:@"" forKey:kAlertType];
        
        
        NSString *gpId = skuVoidsObj.gpId;
        if([SIUtiliesController checkForNull:gpId forParameter:[NSString class]]) {
            [skuAlertsDict setObject:gpId forKey:kGPID];
        }
        else
            [skuAlertsDict setObject:@"" forKey:kGPID];
        
        NSString *alertID = skuVoidsObj.alertID;
        if([SIUtiliesController checkForNull:alertID forParameter:[NSString class]]) {
            [skuAlertsDict setObject:skuVoidsObj.alertID forKey:kAlertID];
            
        }
        else
            [skuAlertsDict setObject:@"" forKey:kAlertID];
        
        NSString *upc = skuVoidsObj.upcCode;
        if([SIUtiliesController checkForNull:upc forParameter:[NSString class]]) {
            [skuAlertsDict setObject:skuVoidsObj.upcCode forKey:kUPC];
            
        }
        else
            [skuAlertsDict setObject:@"" forKey:kUPC];
        
        NSString *mfoId = skuVoidsObj.mfoId;
        if([SIUtiliesController checkForNull:mfoId forParameter:[NSString class]]) {
            [skuAlertsDict setObject:skuVoidsObj.mfoId forKey:kMfoId];
            
        }
        else
            [skuAlertsDict setObject:@"" forKey:kMfoId];
        
        
        NSString *alt_Upc = skuVoidsObj.altUPCCode;
        if([SIUtiliesController checkForNull:alt_Upc forParameter:[NSString class]]) {
            [skuAlertsDict setObject:skuVoidsObj.altUPCCode forKey:kAltUPC];
        }
        else
            [skuAlertsDict setObject:@"" forKey:kAltUPC];
        
        NSString *skuName = skuVoidsObj.skuName;
        if([SIUtiliesController checkForNull:skuName forParameter:[NSString class]]) {
            [skuAlertsDict setObject:skuVoidsObj.skuName forKey:kSkuName];
        }
        else
            [skuAlertsDict setObject:@"" forKey:kSkuName];
        
        NSString *skuVelocity = skuVoidsObj.skuVelocity;
        if([SIUtiliesController checkForNull:skuVelocity forParameter:[NSString class]]) {
            [skuAlertsDict setObject:skuVoidsObj.skuVelocity forKey:kSKUVelocity];
        }
        else
            [skuAlertsDict setObject:@"" forKey:kSKUVelocity];
        
        NSString *skuRank = skuVoidsObj.skuRank;
        if([SIUtiliesController checkForNull:skuRank forParameter:[NSString class]]) {
            [skuAlertsDict setObject:skuVoidsObj.skuRank forKey:kSKURank];
        }
        else
            [skuAlertsDict setObject:@"" forKey:kSKURank];
        
        NSString *skuRate = skuVoidsObj.skuRate;
        if([SIUtiliesController checkForNull:skuRate forParameter:[NSString class]]) {
            [skuAlertsDict setObject:skuVoidsObj.skuRate forKey:kskuRate];
        }
        else
            [skuAlertsDict setObject:@"" forKey:kskuRate];
        
        NSString *version = skuVoidsObj.version;
        if([SIUtiliesController checkForNull:version forParameter:[NSString class]]) {
            [skuAlertsDict setObject:skuVoidsObj.version forKey:kVersion];
            
        }
        else
            [skuAlertsDict setObject:@"" forKey:kVersion];
        
        //code by Nisha for get isNoActionEnabled,isYesActionEnabled
        
        
        if([SIUtiliesController checkForNull:skuVoidsObj.isYesActionEnabled forParameter:[NSNumber class]])
            [skuAlertsDict setObject:skuVoidsObj.isYesActionEnabled forKey:kYesActionEnabled];
        else
            [skuAlertsDict setObject:[NSNumber numberWithBool:NO]forKey:kYesActionEnabled];
        
        if([SIUtiliesController checkForNull:skuVoidsObj.isNoActionEnabled forParameter:[NSNumber class]])
            [skuAlertsDict setObject:skuVoidsObj.isNoActionEnabled forKey:kNoActionEnabled];
        else
            [skuAlertsDict setObject:[NSNumber numberWithBool:NO]forKey:kNoActionEnabled];
        
        NSString *invenID = skuVoidsObj.invenID;
        if([SIUtiliesController checkForNull:invenID forParameter:[NSString class]]) {
            [skuAlertsDict setObject:skuVoidsObj.invenID forKey:kinvenID];
            
        }
        else
            [skuAlertsDict setObject:@"" forKey:kinvenID];
//////////

        
        if(skuVoidsObj.skuAlertAction!=nil)
            [skuAlertsDict setObject:skuVoidsObj.skuAlertAction forKey:kActionedFlag];
        
        if (skuVoidsObj.skuActionedDate!=nil) {
            [skuAlertsDict setObject:skuVoidsObj.skuActionedDate forKey:kActionedDate];
            
            [actionedAlerts addObject:skuAlertsDict];
        }
        else
            [unactionedAlerts addObject:skuAlertsDict];
        
    }
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kUPC ascending:YES];
//    
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:
//                                sortDescriptor,
//                                nil];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kSkuName ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                sortDescriptor,
                                nil];
    
    
    NSSortDescriptor *actionedDescriptor=[[NSSortDescriptor alloc] initWithKey:kActionedDate ascending:NO];
    NSSortDescriptor *sortSKUName = [[NSSortDescriptor alloc] initWithKey:kSkuName ascending:YES];
    NSArray *actionedDescriptors=[NSArray arrayWithObjects:actionedDescriptor,sortSKUName, nil];
    
    
    
    
    
    NSArray * sortedActionedArray = [actionedAlerts sortedArrayUsingDescriptors:actionedDescriptors];
    
    NSArray * sortedUnactionedArray = [unactionedAlerts sortedArrayUsingDescriptors:sortDescriptors];
    [skuVoidsDict setObject:sortedActionedArray forKey:kActioned];
    [skuVoidsDict setObject:sortedUnactionedArray forKey:kUnActioned];
    
    
    
    return skuVoidsDict;
    
}


#pragma mark-Missing SKU in POG

-(void)insertMissingSKUAlerts:(NSArray *)missingSKUAlertsArray forActionedAlerts:(BOOL)isActionedAlert withAlertsInfo:(NSDictionary *)alertInfoDict{
    
    NSError *error;
    NSManagedObjectContext *context = [[SICoreDataHandler sharedInstance] managedObjectContext];
    
    
    Configuration *configObj=[self fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    if (configObj.isMissingSKUs) {
        for (NSDictionary *missingSKUAlerts in missingSKUAlertsArray) {
            
            MissingSKUinPOG *missingSKU;
            
            missingSKU=[self fetchMissingSKUForUPCCode:[missingSKUAlerts objectForKey:kUPC] andConfiguration:configObj  andVersion:[missingSKUAlerts objectForKey:kVersion]];
            
            
            
            if (missingSKU==nil && [SIUtiliesController checkForNull:[missingSKUAlerts objectForKey:kUPC]forParameter:[NSString class]]) {
                
                
                
                missingSKU=[NSEntityDescription insertNewObjectForEntityForName:kMissingSKUinPOGEntity inManagedObjectContext:context];
                
                if (isActionedAlert) {
                    
                    NSString *actionedDate =[missingSKUAlerts objectForKey:kActionedDate];
                    
                    if (actionedDate!=nil) {
                        missingSKU.pogActionedDate=actionedDate;
                    }
                    
                }
                NSString *actionedFlag=[missingSKUAlerts objectForKey:kActionedFlag];
                missingSKU.pogAlertAction=actionedFlag;
                
                
                NSString *alertType=[alertInfoDict objectForKey:kAlertType];
                if([SIUtiliesController checkForNull:alertType forParameter:[NSString class]]) {
                    missingSKU.alertType=alertType;
                }
                else
                    missingSKU.alertType=@"";
                
                NSString *alertID=[alertInfoDict objectForKey:kAlertID];
                if([SIUtiliesController checkForNull:alertID forParameter:[NSString class]]) {
                    missingSKU.alertID=alertID;
                }
                else
                    missingSKU.alertID=@"";
                
                NSString *gpId=[missingSKUAlerts objectForKey:kGPID];
                if([SIUtiliesController checkForNull:gpId forParameter:[NSString class]]) {
                    missingSKU.gpId=gpId;
                }
                else
                    missingSKU.gpId=@"";
                
                
                NSString *upcCode=[missingSKUAlerts objectForKey:kUPC];
                if([SIUtiliesController checkForNull:upcCode forParameter:[NSString class]]) {
                    missingSKU.upcCode=upcCode;
                }
                else
                    missingSKU.upcCode=@"";
                
                NSString *altUPCCode=[missingSKUAlerts objectForKey:kAltUPC];
                if([SIUtiliesController checkForNull:altUPCCode forParameter:[NSString class]]) {
                    missingSKU.altUPCCode=altUPCCode;
                }
                else
                    missingSKU.altUPCCode=@"";
                
                NSString *version=[missingSKUAlerts objectForKey:kVersion];
                if([SIUtiliesController checkForNull:version forParameter:[NSString class]]) {
                    missingSKU.version=version;
                }
                else
                    missingSKU.version=@"";
                
                NSString *missingSKUName=[missingSKUAlerts objectForKey:kSkuName];
                if([SIUtiliesController checkForNull:missingSKUName forParameter:[NSString class]]) {
                    missingSKU.missingSKUName=missingSKUName;
                }
                else
                    missingSKU.missingSKUName=@"";
                
                NSString *mfoID=[missingSKUAlerts objectForKey:kMfoId];
                if([SIUtiliesController checkForNull:mfoID forParameter:[NSString class]]) {
                    missingSKU.mfoId=mfoID;
                }
                else
                    missingSKU.mfoId=@"";
                
                // insert isYesActionEnabled, isYesActionEnabled
                
                if ([SIUtiliesController checkForNull:[missingSKUAlerts objectForKey:kYesActionEnabled] forParameter:[NSNumber class]])
                    missingSKU.isYesActionEnabled=[NSNumber numberWithBool:YES];
                else
                    missingSKU.isYesActionEnabled=[NSNumber numberWithBool:NO];
                
                if ([SIUtiliesController checkForNull:[missingSKUAlerts objectForKey:kNoActionEnabled] forParameter:[NSNumber class]])
                    missingSKU.isNoActionEnabled=[NSNumber numberWithBool:YES];
                else
                    missingSKU.isNoActionEnabled=[NSNumber numberWithBool:NO];
                
                ////
                
                
                [configObj addMissingSKUObject:missingSKU];
                
                
                if ([context save:&error])
                {
                    DebugLog(@"missingSKU saved to DB successfully");
                }
                else
                    DebugLog(kFailed);
            }
            else if(missingSKU!=nil){
               
                [self updateMissingSKUAlertsForActionType:missingSKU withDictionary:missingSKUAlerts];
            }
        }
    }
    
}

-(MissingSKUinPOG *)fetchMissingSKUForUPCCode:(NSString *)upcCode andConfiguration:(Configuration *)configObj andVersion:(NSString *)version{
    
    MissingSKUinPOG *missingSKUObj;
    
    NSArray *missingSKUAlertsArray = [configObj.missingSKU allObjects];
    
    NSPredicate *upcPredicate=[NSPredicate predicateWithFormat:@"upcCode==%@",upcCode];
    NSPredicate *versionPredicate=[NSPredicate predicateWithFormat:@"version==%@",version];
    NSCompoundPredicate *compoundPredicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[upcPredicate,versionPredicate]];
    
    NSArray *tempArray =[missingSKUAlertsArray filteredArrayUsingPredicate:compoundPredicate];
    
    if (tempArray.count>0) {
        for (MissingSKUinPOG *missingObj in tempArray) {
            missingSKUObj=missingObj;
        }
        
    }
    else
        missingSKUObj=nil;
    
    return missingSKUObj;
    
}

-(void)updateMissingSKUAlertsForActionType:(MissingSKUinPOG *)missingSKUObj withDictionary:(NSDictionary *)alertDict {
    
            if ([SIUtiliesController checkForNull:[alertDict objectForKey:kVersion] forParameter:[NSString class]]) {
                if ([missingSKUObj.version isEqual:[alertDict objectForKey:kVersion]]) {
                    NSString *actionedDate =[alertDict objectForKey:kActionedDate];
                    NSString *gpID =[alertDict objectForKey:kGPID];
                    
                    if ([SIUtiliesController checkForNull:actionedDate forParameter:[NSString class]])
                        missingSKUObj.pogActionedDate=actionedDate;
                    
                    
                    if ([SIUtiliesController checkForNull:gpID forParameter:[NSString class]] && ![SIUtiliesController checkForNull:missingSKUObj.gpId forParameter:[NSString class]])
                        missingSKUObj.gpId=gpID;
                    
                        [self saveContext];
            }
        }
}



-(NSMutableDictionary *)getmissingSKUAlertsForConfiguration:(Configuration *)configObj{
    
    NSArray *alertsArray=[configObj.missingSKU allObjects];
    
    NSMutableDictionary *missingSKUAlertsDict,*missingSkuDict;
    
    NSMutableArray *actionedAlerts=[NSMutableArray new];
    NSMutableArray *unactionedAlerts=[NSMutableArray new];
    missingSkuDict=[NSMutableDictionary dictionary];
    
    for (MissingSKUinPOG *missingSKUObj in alertsArray) {
        
        missingSKUAlertsDict=[NSMutableDictionary new];
        
        
        
        NSString *gpId = missingSKUObj.gpId;
        if([SIUtiliesController checkForNull:gpId forParameter:[NSString class]]) {
            [missingSKUAlertsDict setObject:gpId forKey:kGPID];
        }
        else
            [missingSKUAlertsDict setObject:@"" forKey:kGPID];
        
        
        NSString *alertType = missingSKUObj.alertType;
        if([SIUtiliesController checkForNull:alertType forParameter:[NSString class]]) {
            [missingSKUAlertsDict setObject:missingSKUObj.alertType forKey:kAlertType];
        }
        else
            [missingSKUAlertsDict setObject:@"" forKey:kAlertType];
        
        NSString *alertID = missingSKUObj.alertID;
        if([SIUtiliesController checkForNull:alertID forParameter:[NSString class]]) {
            [missingSKUAlertsDict setObject:missingSKUObj.alertID forKey:kAlertID];
            
        }
        else
            [missingSKUAlertsDict setObject:@"" forKey:kAlertID];
        
        NSString *upcCode = missingSKUObj.upcCode;
        if([SIUtiliesController checkForNull:upcCode forParameter:[NSString class]]) {
            [missingSKUAlertsDict setObject:missingSKUObj.upcCode forKey:kUPC];
        }
        else
            [missingSKUAlertsDict setObject:@"" forKey:kUPC];
        
        NSString *alt_Upc = missingSKUObj.altUPCCode;
        if([SIUtiliesController checkForNull:alt_Upc forParameter:[NSString class]]) {
            [missingSKUAlertsDict setObject:missingSKUObj.altUPCCode forKey:kAltUPC];
            
        }
        else
            [missingSKUAlertsDict setObject:@"" forKey:kAltUPC];
        
        NSString *version = missingSKUObj.version;
        if([SIUtiliesController checkForNull:version forParameter:[NSString class]]) {
            [missingSKUAlertsDict setObject:missingSKUObj.version forKey:kVersion];
        }
        else
            [missingSKUAlertsDict setObject:@"" forKey:kVersion];
        
        NSString *mfoId = missingSKUObj.mfoId;
        if([SIUtiliesController checkForNull:mfoId forParameter:[NSString class]]) {
            [missingSKUAlertsDict setObject:mfoId forKey:kMfoId];
        }
        else
            [missingSKUAlertsDict setObject:@"" forKey:kMfoId];
        
        
        NSString *missingSKUName = missingSKUObj.missingSKUName;
        if([SIUtiliesController checkForNull:missingSKUName forParameter:[NSString class]]) {
            [missingSKUAlertsDict setObject:missingSKUObj.missingSKUName forKey:kSkuName];
        }
        else
            [missingSKUAlertsDict setObject:@"" forKey:kSkuName];
        
        if (missingSKUObj.pogAlertAction!=nil) {
            [missingSKUAlertsDict setObject:missingSKUObj.pogAlertAction forKey:kActionedFlag];
        }
        else
            [missingSKUAlertsDict setObject:@"" forKey:kActionedFlag];
        
        //code by Nisha for get isNoActionEnabled,isYesActionEnabled
        
        if([SIUtiliesController checkForNull:missingSKUObj.isYesActionEnabled forParameter:[NSNumber class]])
            [missingSKUAlertsDict setObject:missingSKUObj.isYesActionEnabled forKey:kYesActionEnabled];
        else
            [missingSKUAlertsDict setObject:[NSNumber numberWithBool:NO]forKey:kYesActionEnabled];
        
        if([SIUtiliesController checkForNull:missingSKUObj.isNoActionEnabled forParameter:[NSNumber class]])
            [missingSKUAlertsDict setObject:missingSKUObj.isNoActionEnabled forKey:kNoActionEnabled];
        else
            [missingSKUAlertsDict setObject:[NSNumber numberWithBool:NO]forKey:kNoActionEnabled];

        
        ///////////

        
        if (missingSKUObj.pogActionedDate!=nil) {
            [missingSKUAlertsDict setObject:missingSKUObj.pogActionedDate forKey:kActionedDate];
            
            [actionedAlerts addObject:missingSKUAlertsDict];
        }
        else
            [unactionedAlerts addObject:missingSKUAlertsDict];
        
    }
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kUPC ascending:YES];
//    
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:
//                                sortDescriptor,
//                                nil];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kSkuName ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                sortDescriptor,
                                nil];
    
    
    NSSortDescriptor *actionedDescriptor=[[NSSortDescriptor alloc] initWithKey:kActionedDate ascending:NO];
    NSSortDescriptor *sortSKUName = [[NSSortDescriptor alloc] initWithKey:kSkuName ascending:YES];
    NSArray *actionedDescriptors=[NSArray arrayWithObjects:actionedDescriptor,sortSKUName, nil];
    
    
    NSArray * sortedActionedArray = [actionedAlerts sortedArrayUsingDescriptors:actionedDescriptors];
    
    NSArray * sortedUnactionedArray = [unactionedAlerts sortedArrayUsingDescriptors:sortDescriptors];
    [missingSkuDict setObject:sortedActionedArray forKey:kActioned];
    
    [missingSkuDict setObject:sortedUnactionedArray forKey:kUnActioned];
    
    return missingSkuDict;
    
}

-(BOOL)isActionedALertSavedLocal:(Configuration *)configObj{
    //Missing SKUVoid
    NSArray *aryMissingSKU=[configObj.missingSKU allObjects];
    NSPredicate *predicateMissingSKU = [NSPredicate predicateWithFormat:@"self.respondedFlag == 0 && (self.pogAlertAction ==[c] %@ || self.pogAlertAction ==[c] %@) && ((self.pogActionedDate == nil) OR self.pogActionedDate.length == 0)", @"Y",@"N"];
    NSArray *filteredAryMissingSKU = [aryMissingSKU filteredArrayUsingPredicate:predicateMissingSKU];
    
    // SKU Void
    NSArray *arySKUVoid =[configObj.skuVoid allObjects];
    NSPredicate *predicateSKUVoid = [NSPredicate predicateWithFormat:@"self.respondedFlag == 0 && (self.skuAlertAction ==[c] %@ || self.skuAlertAction ==[c] %@) && ((self.skuActionedDate == nil) OR self.skuActionedDate.length == 0)", @"Y",@"N"];
    NSArray *filteredArySKUVoid = [arySKUVoid filteredArrayUsingPredicate:predicateSKUVoid];
    
    
    // Innovation
    NSArray *aryInno=[configObj.innovation allObjects];
    NSPredicate *predicateInno = [NSPredicate predicateWithFormat:@"self.respondedFlag == 0 && (self.innovationAlertAction ==[c] %@ || self.innovationAlertAction ==[c] %@) && ((self.innovationActionedDate == nil) OR self.innovationActionedDate.length == 0)", @"Y",@"N"];
    NSArray *filteredAryInno = [aryInno filteredArrayUsingPredicate:predicateInno];
    
    // Pureplay
    NSArray *aryPurePlay=[configObj.purePlay allObjects];
    NSPredicate *predicatePurePlay = [NSPredicate predicateWithFormat:@"self.respondedFlag == 0 && (self.ppAction ==[c] %@ || self.ppAction ==[c] %@) && ((self.ppActionedDate == nil) OR self.ppActionedDate.length == 0)", @"Y",@"N"];
    NSArray *filteredAryPurePlay = [aryPurePlay filteredArrayUsingPredicate:predicatePurePlay];

    if(filteredAryInno.count > 0 || filteredAryMissingSKU.count > 0 || filteredAryPurePlay.count > 0 || filteredArySKUVoid.count > 0){
        return YES;
    }
    
    return NO;
}

#pragma mark-Innovation Alerts

-(void)insertInnovationAlerts:(NSArray *)innovationAlertsArray forActionedAlerts:(BOOL)isActionedAlert withAlertsInfo:(NSDictionary *)alertInfoDict{
    NSError *error;
    NSManagedObjectContext *context = [[SICoreDataHandler sharedInstance] managedObjectContext];
    
    
    Configuration *configObj=[self fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    if (configObj.isInnovation) {
        for (NSDictionary *innovationAlertsDict in innovationAlertsArray) {
            
            Innovation *innovation;
            
            innovation=[self fetchInnovationForUPCCode:[innovationAlertsDict objectForKey:kUPC] andConfiguration:configObj andVersion:[innovationAlertsDict objectForKey:kVersion]];
            
            

            
            
            
            if (innovation==nil && [SIUtiliesController checkForNull:[innovationAlertsDict objectForKey:kUPC]forParameter:[NSString class]]) {
                
                innovation=[NSEntityDescription insertNewObjectForEntityForName:kInnovationEntity inManagedObjectContext:context];
                
                if (isActionedAlert) {
                    
                    NSString *actionedDate =[innovationAlertsDict objectForKey:kActionedDate];
                    
                    if (actionedDate!=nil) {
                        innovation.innovationActionedDate=actionedDate;
                        
                    }
                    
                }
                NSString *actionedFlag=[innovationAlertsDict objectForKey:kActionedFlag];
                innovation.innovationAlertAction=actionedFlag;
                
                
                NSString *alertType=[alertInfoDict objectForKey:kAlertType];
                if([SIUtiliesController checkForNull:alertType forParameter:[NSString class]]) {
                    innovation.alertType=alertType;
                }
                else
                    innovation.alertType=@"";
                
                NSString *alertID=[alertInfoDict objectForKey:kAlertID];
                if([SIUtiliesController checkForNull:alertID forParameter:[NSString class]]) {
                    innovation.alertID=alertID;
                }
                else
                    innovation.alertID=@"";
                
                NSString *upcCode=[innovationAlertsDict objectForKey:kUPC];
                if([SIUtiliesController checkForNull:upcCode forParameter:[NSString class]]) {
                    innovation.upcCode=upcCode;
                }
                else
                    innovation.upcCode=@"";
                
                NSString *gpId=[innovationAlertsDict objectForKey:kGPID];
                if([SIUtiliesController checkForNull:gpId forParameter:[NSString class]]) {
                    innovation.gpId=gpId;
                }
                else
                    innovation.gpId=@"";
                
                
                NSString *altUPCCode=[innovationAlertsDict objectForKey:kAltUPC];
                if([SIUtiliesController checkForNull:altUPCCode forParameter:[NSString class]]) {
                    innovation.altUPCCode=altUPCCode;
                }
                else
                    innovation.altUPCCode=@"";
                
                
                NSString *version=[innovationAlertsDict objectForKey:kVersion];
                if([SIUtiliesController checkForNull:version forParameter:[NSString class]]) {
                    innovation.version=version;
                }
                else
                    innovation.version=@"";
                
                NSString *startDate=[innovationAlertsDict objectForKey:kInnovationStartDate];
                if([SIUtiliesController checkForNull:alertType forParameter:[NSString class]]) {
                    innovation.startDate=startDate;
                }
                else
                    innovation.startDate=@"";
                
                
                NSString *endDate=[innovationAlertsDict objectForKey:kInnovationEndDate];
                if([SIUtiliesController checkForNull:endDate forParameter:[NSString class]]) {
                    innovation.endDate=endDate;
                }
                else
                    innovation.endDate=@"";
                
                
                NSString *innovationName=[innovationAlertsDict objectForKey:kSkuName];
                if([SIUtiliesController checkForNull:innovationName forParameter:[NSString class]]) {
                    innovation.innovationName=innovationName;
                }
                else
                    innovation.innovationName=@"";
                
                NSString *mfoId=[innovationAlertsDict objectForKey:kMfoId];
                if([SIUtiliesController checkForNull:mfoId forParameter:[NSString class]]) {
                    innovation.mfoId=mfoId;
                }
                else
                    innovation.mfoId=@"";
                
                // insert isYesActionEnabled, isYesActionEnabled
                
                if ([SIUtiliesController checkForNull:[innovationAlertsDict objectForKey:kYesActionEnabled] forParameter:[NSNumber class]])
                    innovation.isYesActionEnabled=[NSNumber numberWithBool:YES];
                else
                    innovation.isYesActionEnabled=[NSNumber numberWithBool:NO];
                
                if ([SIUtiliesController checkForNull:[innovationAlertsDict objectForKey:kNoActionEnabled] forParameter:[NSNumber class]])
                    innovation.isNoActionEnabled=[NSNumber numberWithBool:YES];
                else
                    innovation.isNoActionEnabled=[NSNumber numberWithBool:NO];
                
                ////
                
                [configObj addInnovationObject:innovation];
                
                
                if ([context save:&error])
                {
                    DebugLog(@"innovation saved to DB successfully");
                }
                else
                    DebugLog(kFailed);
                
            }
            else if(innovation!=nil){
                [self updateInnovationAlertsForActionType:innovation withDictionary:innovationAlertsDict];
                
            }
        }
        
    }
    
    
    
    
}

-(Innovation *)fetchInnovationForUPCCode:(NSString *)upcCode andConfiguration:(Configuration *)configObj andVersion:(NSString *)version{
    
    Innovation *innovationObj;
    NSArray *innovationAlertsArray = [configObj.innovation allObjects];
    NSPredicate *upcPredicate=[NSPredicate predicateWithFormat:@"upcCode==%@",upcCode];
    NSPredicate *versionPredicate=[NSPredicate predicateWithFormat:@"version==%@",version];
    NSCompoundPredicate *compoundPredicate=[NSCompoundPredicate andPredicateWithSubpredicates:@[upcPredicate,versionPredicate]];
    
    NSArray *tempArray =[innovationAlertsArray filteredArrayUsingPredicate:compoundPredicate];
    
    if (tempArray.count>0) {
        for (Innovation *innObj in tempArray) {
            innovationObj=innObj;
        }
        
    }
    else
        innovationObj=nil;
    
    return innovationObj;
    
}

-(void)updateInnovationAlertsForActionType:(Innovation *)innovationObj withDictionary:(NSDictionary *)alertDict{

            if ([SIUtiliesController checkForNull:[alertDict objectForKey:kVersion] forParameter:[NSString class]]) {
                if ([innovationObj.version isEqual:[alertDict objectForKey:kVersion]]) {
                    
                    NSString *actionedDate =[alertDict objectForKey:kActionedDate];
                    
                    NSString *gpID =[alertDict objectForKey:kGPID];
                    
                    if ([SIUtiliesController checkForNull:actionedDate forParameter:[NSString class]])
                        innovationObj.innovationActionedDate=actionedDate;
                    
                    
                    if ([SIUtiliesController checkForNull:gpID forParameter:[NSString class]] && ![SIUtiliesController checkForNull:innovationObj.gpId forParameter:[NSString class]])
                    {
                            innovationObj.gpId=gpID;
                    }
                    
                        [self saveContext];
                }
            }
}



-(NSMutableDictionary *)getInnovationAlertsForConfiguration:(Configuration *)configObj{
    
    NSArray *alertsArray=[configObj.innovation allObjects];
    
    NSMutableDictionary *innovationAlertsDict,*innovationDict;
    NSMutableArray *actionedAlerts=[NSMutableArray new];
    NSMutableArray *unactionedAlerts=[NSMutableArray new];
    innovationDict=[NSMutableDictionary dictionary];
    
    
    for (Innovation *innovationObj in alertsArray) {
        
        innovationAlertsDict=[NSMutableDictionary new];
        
        NSString *gpId = innovationObj.gpId;
        if([SIUtiliesController checkForNull:gpId forParameter:[NSString class]]) {
            [innovationAlertsDict setObject:gpId forKey:kGPID];
        }
        else
            [innovationAlertsDict setObject:@"" forKey:kGPID];
        
        
        
        NSString *alertType = innovationObj.alertType;
        if([SIUtiliesController checkForNull:alertType forParameter:[NSString class]]) {
            [innovationAlertsDict setObject:innovationObj.alertType forKey:kAlertType];
        }
        else
            [innovationAlertsDict setObject:@"" forKey:kAlertType];
        
        NSString *alertID = innovationObj.alertID;
        if([SIUtiliesController checkForNull:alertID forParameter:[NSString class]]) {
            [innovationAlertsDict setObject:innovationObj.alertID forKey:kAlertID];
        }
        else
            [innovationAlertsDict setObject:@"" forKey:kAlertID];
        
        NSString *upcCode = innovationObj.upcCode;
        if([SIUtiliesController checkForNull:upcCode forParameter:[NSString class]]) {
            [innovationAlertsDict setObject:innovationObj.upcCode forKey:kUPC];
        }
        else
            [innovationAlertsDict setObject:@"" forKey:kUPC];
        
        NSString *altUPCCode = innovationObj.altUPCCode;
        if([SIUtiliesController checkForNull:altUPCCode forParameter:[NSString class]]) {
            [innovationAlertsDict setObject:innovationObj.altUPCCode forKey:kAltUPC];
        }
        else
            [innovationAlertsDict setObject:@"" forKey:kAltUPC];
        
        NSString *version = innovationObj.version;
        if([SIUtiliesController checkForNull:version forParameter:[NSString class]]) {
            [innovationAlertsDict setObject:innovationObj.version forKey:kVersion];
        }
        else
            [innovationAlertsDict setObject:@"" forKey:kVersion];
        
        NSString *innovationName = innovationObj.innovationName;
        if([SIUtiliesController checkForNull:innovationName forParameter:[NSString class]]) {
            [innovationAlertsDict setObject:innovationObj.innovationName forKey:kSkuName];
        }
        else
            [innovationAlertsDict setObject:@"" forKey:kSkuName];
        
        NSString *startDate = innovationObj.startDate;
        if([SIUtiliesController checkForNull:startDate forParameter:[NSString class]]) {
            [innovationAlertsDict setObject:innovationObj.startDate forKey:kInnovationStartDate];
        }
        else
            [innovationAlertsDict setObject:@"" forKey:kInnovationStartDate];
        
        NSString *endDate = innovationObj.endDate;
        if([SIUtiliesController checkForNull:endDate forParameter:[NSString class]]) {
            [innovationAlertsDict setObject:innovationObj.endDate forKey:kInnovationEndDate];
        }
        else
            [innovationAlertsDict setObject:@"" forKey:kInnovationEndDate];
        
        NSString *mfoID = innovationObj.mfoId;
        if([SIUtiliesController checkForNull:mfoID forParameter:[NSString class]]) {
            [innovationAlertsDict setObject:mfoID forKey:kMfoId];
        }
        else
            [innovationAlertsDict setObject:@"" forKey:kMfoId];
        
        //code by Nisha for get isNoActionEnabled,isYesActionEnabled
        
        if([SIUtiliesController checkForNull:innovationObj.isYesActionEnabled forParameter:[NSNumber class]])
            [innovationAlertsDict setObject:innovationObj.isYesActionEnabled forKey:kYesActionEnabled];
        else
            [innovationAlertsDict setObject:[NSNumber numberWithBool:NO]forKey:kYesActionEnabled];
        
        if([SIUtiliesController checkForNull:innovationObj.isNoActionEnabled forParameter:[NSNumber class]])
            [innovationAlertsDict setObject:innovationObj.isNoActionEnabled forKey:kNoActionEnabled];
        else
            [innovationAlertsDict setObject:[NSNumber numberWithBool:NO]forKey:kNoActionEnabled];
    ///////
        
        if (innovationObj.innovationAlertAction!=nil) {
            [innovationAlertsDict setObject:innovationObj.innovationAlertAction forKey:kActionedFlag];
        }
        else
            [innovationAlertsDict setObject:@"" forKey:kActionedFlag];

        
        if ([SIUtiliesController checkForNull:innovationObj.innovationActionedDate forParameter:[NSString class]]) {
            [innovationAlertsDict setObject:innovationObj.innovationActionedDate forKey:kActionedDate];
            [actionedAlerts addObject:innovationAlertsDict];
        }
        else
            [unactionedAlerts addObject:innovationAlertsDict];
        
        
        
    }
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kUPC ascending:YES];
//    
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:
//                                sortDescriptor,
//                                nil];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kSkuName ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                sortDescriptor,
                                nil];
    
    
    NSSortDescriptor *actionedDescriptor=[[NSSortDescriptor alloc] initWithKey:kActionedDate ascending:NO];
    NSSortDescriptor *sortSKUName = [[NSSortDescriptor alloc] initWithKey:kSkuName ascending:YES];
    NSArray *actionedDescriptors=[NSArray arrayWithObjects:actionedDescriptor,sortSKUName, nil];
    
    
    NSArray * sortedActionedArray = [actionedAlerts sortedArrayUsingDescriptors:actionedDescriptors];
    NSArray * sortedUnactionedArray = [unactionedAlerts sortedArrayUsingDescriptors:sortDescriptors];
    

    [innovationDict setObject:sortedActionedArray forKey:kActioned];
    [innovationDict setObject:sortedUnactionedArray forKey:kUnActioned];
    
    
    return innovationDict;
    
}


#pragma mark-Common Alerts Modified


-(void)takeActionForAlerts:(int)alertType withParameter:(NSString *)parameter toActionedFlag:(NSString *)actionedType andConfiguration:(Configuration *)configObj andVersion:(NSString *)version{
    
    NSError *error;
    NSManagedObjectContext *context = [[SICoreDataHandler sharedInstance] managedObjectContext];
    
    if (alertType==MISSINGSKUSINPOG) {
        
        MissingSKUinPOG *missingObj=[self fetchMissingSKUForUPCCode:parameter andConfiguration:configObj andVersion:version];
        
        missingObj.pogAlertAction=actionedType;
        
        
    }
    else if (alertType==SKUVOIDS) {
        
        SKUVoids *skuVoidObj=[self fetchSKUVoidsForUPCCode:parameter andConfiguration:configObj  andVersion:version];
        skuVoidObj.skuAlertAction=actionedType;
        
    }
    else if (alertType==PUREPLAY) {
        
        Pureplay *purePlayObj=[self fetchPurePlayForQuestionID:parameter andConfiguration:configObj andVersion:version];
        purePlayObj.ppAction=actionedType;
        
    }
    else if (alertType==INNOVATION) {
        
        Innovation *innovationObj=[self fetchInnovationForUPCCode:parameter andConfiguration:configObj  andVersion:version];
        innovationObj.innovationAlertAction=actionedType;
        
    }
    if ([context save:&error])
    {
        DebugLog(@"takeAction saved to DB successfully");
    }
    else
        DebugLog(kFailed);
    
    
}


-(void)insertSKUVoidsRateValue:(NSString *)rateValue withUPCCode:(NSString *)upcCode andVersion:(NSString *)version{
    
    
    NSError *error;
    NSManagedObjectContext *context = [[SICoreDataHandler sharedInstance] managedObjectContext];
    Configuration* configObj=[[SICoreDataManager sharedDataManager] fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    
    SKUVoids *skuVoidObj=[self fetchSKUVoidsForUPCCode:upcCode andConfiguration:configObj  andVersion:version] ;
    skuVoidObj.skuRate=rateValue;
    
    if ([context save:&error])
    {
        DebugLog(@"rate Value saved to DB successfully");
    }
    else
        DebugLog(kFailed);
    
    
}

#pragma mark - clear data for particular store

-(void)clearDataForStoreId:(NSString *)storeId{
   
    NSManagedObjectContext *context = [[SICoreDataHandler sharedInstance] managedObjectContext];
    
    Configuration *config;
    
    config=[self fetchConfigurationDetailsForstoreID:storeId];
    
    
    if (config!=nil) {
        [context deleteObject:config];
    }

//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[[SICoreDataHandler sharedInstance]managedObjectContext]];
//    [fetchRequest setEntity:entity];
//    
//    NSError *error;
//    NSArray *items = [[[SICoreDataHandler sharedInstance]managedObjectContext] executeFetchRequest:fetchRequest error:&error];
//    
//    
//    for (NSManagedObject *managedObject in items) {
//        [[[SICoreDataHandler sharedInstance]managedObjectContext] deleteObject:managedObject];
//        DebugLog(@"%@ object deleted",entityDescription);
//    }
//    if (![[[SICoreDataHandler sharedInstance]managedObjectContext] save:&error]) {
//        DebugLog(@"Error deleting %@ - error:%@",entityDescription,error);
//    }
}

-(void)clearAllTableData{
    
    NSString *storePath = [[[SICoreDataHandler sharedInstance]applicationDocumentsDirectory]stringByAppendingPathComponent:@"SellingIntelligence.sqlite"];
    
    NSError *error = nil;
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    
    NSPersistentStore *store = [[[SICoreDataHandler sharedInstance]persistentStoreCoordinator] persistentStoreForURL:storeUrl];
    
    [[[SICoreDataHandler sharedInstance]persistentStoreCoordinator] removePersistentStore:store error:&error];
    
    [[NSFileManager defaultManager] removeItemAtPath:storePath error:&error];
    
}

#pragma mark- Update Alerts On Submission Versioning Concept.

-(void)saveMissingSKUAlertsSubmitted:(NSArray *)missingAlertsArray{
    
    Configuration *configObj=[self fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    missingAlertsArray=[configObj.missingSKU allObjects];
    
    for (MissingSKUinPOG *missingSKUObj in missingAlertsArray) {
        
        if (([missingSKUObj.pogAlertAction isEqualToString:kYes] || [missingSKUObj.pogAlertAction isEqualToString:kNo]) && [missingSKUObj.respondedFlag isEqual:[NSNumber numberWithBool:NO]]) {
            
            missingSKUObj.respondedFlag=[NSNumber numberWithBool:YES];
            [self saveContext];
            
        }
    }
}


-(void)saveSkuAlertsSubmitted:(NSArray *)skuAlertsArray{
    
    Configuration *configObj=[self fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    skuAlertsArray=[configObj.skuVoid allObjects];
    for (SKUVoids *skuObj in skuAlertsArray) {
        
        if (([skuObj.skuAlertAction isEqualToString:kYes] || [skuObj.skuAlertAction isEqualToString:kNo]) && [skuObj.respondedFlag isEqual:[NSNumber numberWithBool:NO]]) {
            
            skuObj.respondedFlag=[NSNumber numberWithBool:YES];
            [self saveContext];
            
        }
        
    }
}


-(void)saveInnovationAlertsSubmitted:(NSArray *)innovationAlertsArray{
    
    Configuration *configObj=[self fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    innovationAlertsArray=[configObj.innovation allObjects];
    
    for (Innovation *innovationObj in innovationAlertsArray) {
        if (([innovationObj.innovationAlertAction isEqualToString:kYes] || [innovationObj.innovationAlertAction isEqualToString:kNo]) && [innovationObj.respondedFlag isEqual:[NSNumber numberWithBool:NO]]) {
            
            innovationObj.respondedFlag=[NSNumber numberWithBool:YES];
            [self saveContext];
        }
    }
}

-(void)savePurePlayAlertsSubmitted:(NSArray *)purePlayAlertsArray{
    
    Configuration *configObj=[self fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    purePlayAlertsArray=[configObj.purePlay allObjects];
    
    
    for (Pureplay *purePlayObj in purePlayAlertsArray) {
        
        if (([purePlayObj.ppAction isEqualToString:kYes] || [purePlayObj.ppAction isEqualToString:kNo]) && [purePlayObj.respondedFlag isEqual:[NSNumber numberWithBool:NO]]) {
            
            purePlayObj.respondedFlag=[NSNumber numberWithBool:YES];
            [self saveContext];
        }
    }
}

-(void)saveSubmittedAlerts{
    
    [self saveInnovationAlertsSubmitted:nil];
    [self saveMissingSKUAlertsSubmitted:nil];
    [self savePurePlayAlertsSubmitted:nil];
    [self saveSkuAlertsSubmitted:nil];
}

- (void)saveContext
{
    NSError *error=nil;
    NSManagedObjectContext *context = [[SICoreDataHandler sharedInstance] managedObjectContext];
    [context save:&error];
}


-(void)getLocalActionAlertFromSku{
    
}

@end
