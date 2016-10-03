//
//  Selling_Intelligence.m
//  Selling Intelligence
//
//  Created by Sailesh on 29/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//


#import "SIBaseLogic.h"
#import "SIReachability.h"
#import "SIUtility.h"
#import "SIUtiliesController.h"
#import "SIWebServiceParser.h"
#import "SIBaseFetchParser.h"
#import "SIAlertsBaseViewController.h"
#import "SellingIntelligence.h"

@implementation SIBaseLogic

@synthesize lastAlertUpdatedTime,delegate;

#pragma mark-Common Methods

+ (instancetype) sharedSIBaseLogic
{
    static SIBaseLogic *sharedBaseLogic = nil;
    static dispatch_once_t once_token;
    
    dispatch_once (&once_token, ^{
        sharedBaseLogic = [[SIBaseLogic alloc] init];
    });
    
    return sharedBaseLogic;
}

+(NSString*)alertEnumToString:(int)selectedAlert {
    NSString *result = nil;
    
    switch(selectedAlert) {
        case SKUVOIDS:
            result = @"SKU Voids";
            break;
        case MISSINGSKUSINPOG:
            result = @"POG SKUs not Ordered";
            break;
        case INNOVATION:
            result = @"Target Innovation Gaps";
            break;
        case PUREPLAY:
            result = @"Pure Play Opportunities";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected Input"];
    }
    
    return result;
}

+(NSString*)alertIDToName:(int)alertID{
    
    NSString *result = nil;
    
    switch(alertID) {
        case 1:
            result = kSKUVoids;
            break;
        case 2:
            result = kSKUMissinginPOG;
            break;
        case 3:
            result = kInnovationOpportunity;
            break;
        case 4:
            result = kPurePlayOpportunity;
            break;
        case 0:
            result=@"No Alerts";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected Input"];
    }
    
    return result;
    
    
}

+(NSMutableArray *)getAlertsBaseArray:(NSMutableArray *)alertsArray{
    
    NSMutableArray *alertsNamesArray=[NSMutableArray array];
    
    
    for (id alertType in alertsArray) {
        
        if ([alertType isEqual:kSKUMissinginPOG]) {
            
            [alertsNamesArray addObject:kMissingSKUPOG];
        }
        if ([alertType isEqual:kSKUVoids]) {
            
            [alertsNamesArray addObject:kSKUVoids];

        }
        if ([alertType isEqual:kInnovationOpportunity]) {
            
            [alertsNamesArray addObject:kInnovationName];

        }
        if ([alertType isEqual:kPurePlayOpportunity]) {
            
            [alertsNamesArray addObject:kPurePlayName];

        }
    }
    
    return alertsNamesArray;
    
}

+(NSBundle *)libraryBundlePath{
    
    NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:kSIBundle];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    return frameworkBundle;
}


#pragma mark-Alerts Parser

-(void)submitAlertsFailed{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SIUtiliesController showAlertWithMessage:kKeySubmissionFailed title:KAPPNAME];
        [[SIUtility sharedUtility] removeProgressView];
        
    });
    
}


-(void)alertsFetchFailedWithError:(SIWebServiceParser* )parser error:(NSError*)error statusCode:(int)statusCode
{
    [[SIUtility sharedUtility] removeProgressView];
    
    
    NSString *errorMessage = error.localizedDescription;
    
    if (statusCode == 403 || [errorMessage isEqualToString:kSESSIONEXPIEDERROR]) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kSessionExpiredNotificationName
                                                           object:nil userInfo:nil];
        [SIUtiliesController showAlertWithMessage:errorMessage title:KAPPNAME delegate:self cancelButtonTitle:nil otherButtonTitle:kOK];
        
    }else if(error.code != -999){
        [SIUtiliesController showAlertWithMessage:errorMessage title:KAPPNAME];
    }
    
}
-(void)getAlertsResponseSuccessful:(NSDictionary *)alertsResponseDict{
    
    
    [self categorizedSellingIntelligence:alertsResponseDict];
    
}

#pragma mark -alerts Insertion


-(void)readAlertsJson
{
    
    NSError* err = nil;
    NSString* dataPath = [[SIBaseLogic libraryBundlePath] pathForResource:@"SellingIntelligenceJ" ofType:@"json"];
    NSDictionary* alertsResponseDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                                             options:kNilOptions
                                                                               error:&err];
    
    [self categorizedSellingIntelligence:alertsResponseDictionary];
}




-(void)categorizedSellingIntelligence:(NSDictionary *)alertsDictionary{
    
    
    NSMutableDictionary *configurationDictionary=[NSMutableDictionary dictionary];
    
    [configurationDictionary addEntriesFromDictionary:[alertsDictionary objectForKey:@"customerInfo"]];
    
    [configurationDictionary setObject:[SIUtiliesController getStoreID] forKey:kStoreID];
    NSDictionary *alertTypesDictionary=[alertsDictionary objectForKey:@"alertTypes"];
    
    NSMutableDictionary *skuVoidsDict=[NSMutableDictionary dictionary];
    NSMutableDictionary *purePlayAlertsDict=[NSMutableDictionary dictionary];
    NSMutableDictionary *missingSKUDict=[NSMutableDictionary dictionary];
    NSMutableDictionary *innovationDict=[NSMutableDictionary dictionary];
    NSMutableDictionary *alertsDetailsDict=[NSMutableDictionary dictionary];
    
    BOOL isPureplay= false;
    BOOL isInnovation= false;
    BOOL  isMissingSkus= false;
    BOOL isSKUVoids = false;
    NSMutableArray *tempArray=[alertsDictionary objectForKey:@"alertTypes"];
    for (id alertType in tempArray) {
        
        alertsDetailsDict=[NSMutableDictionary new];

        [alertsDetailsDict setObject:[SIUtiliesController getStoreID] forKey:kStoreID];
        
        [alertsDetailsDict addEntriesFromDictionary:[alertTypesDictionary objectForKey:alertType]];
        NSString *alertTypeName;
        
        
            int alertID=[[[alertTypesDictionary objectForKey:alertType]objectForKey:kAlertID] intValue] ;
        
        if (alertID<5 && alertID>0) {
            alertTypeName=[SIBaseLogic alertIDToName:alertID];
        }
        
        
        if ([SIUtiliesController checkForNull:alertTypeName forParameter:[NSString class]] && ![alertType isEqualToString:@"No Alerts"]){
            
            [configurationDictionary setObject:[NSNumber numberWithBool:YES] forKey:alertTypeName];
        }
        
        if ([configurationDictionary objectForKey:kPurePlayOpportunity] && !isPureplay)
        {
            purePlayAlertsDict=[NSMutableDictionary dictionaryWithDictionary:alertsDetailsDict];
            if([[skuVoidsDict objectForKey:kUnActionedPurePlay] count] > 0){
                NSString *versionNo = [[[skuVoidsDict objectForKey:kUnActionedPurePlay] objectAtIndex:0]objectForKey:kVersion];
                [configurationDictionary setObject:versionNo forKey:kVersion];
            }
            isPureplay=YES;
        }
        else if([configurationDictionary objectForKey:kSKUVoids] && !isSKUVoids)
        {
            skuVoidsDict=[NSMutableDictionary dictionaryWithDictionary:alertsDetailsDict];
            if([[skuVoidsDict objectForKey:kUnActionedSKUVoids] count] > 0){
                NSString *versionNo = [[[skuVoidsDict objectForKey:kUnActionedSKUVoids] objectAtIndex:0]objectForKey:kVersion];
                [configurationDictionary setObject:versionNo forKey:kVersion];
            }
            
            isSKUVoids=YES;
        }
        else if([configurationDictionary objectForKey:kSKUMissinginPOG] && !isMissingSkus)
        {
            missingSKUDict=[NSMutableDictionary dictionaryWithDictionary:alertsDetailsDict];
            if([[skuVoidsDict objectForKey:kUnActionedMissingSKUs] count] > 0){
                NSString *versionNo = [[[skuVoidsDict objectForKey:kUnActionedMissingSKUs] objectAtIndex:0]objectForKey:kVersion];
                [configurationDictionary setObject:versionNo forKey:kVersion];
            }
            isMissingSkus=YES;
        }
        else if([configurationDictionary objectForKey:kInnovationOpportunity] &&!isInnovation)
        {
            innovationDict=[NSMutableDictionary dictionaryWithDictionary:alertsDetailsDict];
            if([[skuVoidsDict objectForKey:kUnActionedInnovation] count] > 0){
                NSString *versionNo = [[[skuVoidsDict objectForKey:kUnActionedInnovation] objectAtIndex:0]objectForKey:kVersion];
                [configurationDictionary setObject:versionNo forKey:kVersion];
            }
            isInnovation=YES;
        }
        
    }
    
    [[SICoreDataManager sharedDataManager] insertCustomerConfiguration:configurationDictionary];
    
    if (isPureplay)
        [self differentiateActiveAndUnactiveAlerts:purePlayAlertsDict forAlertType:PUREPLAY];
    
    if(isSKUVoids)
        [self differentiateActiveAndUnactiveAlerts:skuVoidsDict forAlertType:SKUVOIDS];
    
    if(isMissingSkus)
        [self differentiateActiveAndUnactiveAlerts:missingSKUDict forAlertType:MISSINGSKUSINPOG];
    
    if(isInnovation)
        [self differentiateActiveAndUnactiveAlerts:innovationDict forAlertType:INNOVATION];
    
    if([SellingIntelligence sharedSellingIntelligenceClass].alertsSubmitted){
        [self refreshUpdatedAlerts];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadAlertsFromServer" object:self];
    }
}



+(NSMutableArray *)unactionedAlertsTypes{
    
    NSMutableArray *unactionedAlerts=[NSMutableArray array];
    NSMutableDictionary *configDict=[NSMutableDictionary dictionary];
    configDict=[[SICoreDataManager sharedDataManager] getConfigurationDetails];
    
    if ([[configDict objectForKey:kIsSKUVoids] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [unactionedAlerts addObject:kSKUVoids];
    }
    if ([[configDict objectForKey:kIsMissingSKUs] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [unactionedAlerts addObject:kSKUMissinginPOG];
    }
    if ([[configDict objectForKey:kIsInnovation] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [unactionedAlerts addObject:kInnovationOpportunity];
    }
    if ([[configDict objectForKey:kIsPurePlay] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [unactionedAlerts addObject:kPurePlayOpportunity];
    }
    
    return unactionedAlerts;
    
}

#pragma mark - compare version of server and local alert

-(BOOL)isLocalAndSeverAlertVersionSame:(NSDictionary *)dicServerAlert storeId:(NSString *)storeId{
    Configuration *config = [[SICoreDataManager sharedDataManager]fetchConfigurationDetailsForstoreID:storeId];
    NSString *verson = [self getServerAlertVersion:dicServerAlert];
    if([verson integerValue] <= [config.version integerValue]){
        return YES;
    }
    return NO;
}

-(NSString *)getServerAlertVersion:(NSDictionary *)dicServerAlert{
    NSDictionary *dicAlertTypes = nil;
    __block NSString *version = nil;
    if([dicServerAlert objectForKey:kAlertTypes]){
        dicAlertTypes = [[NSDictionary alloc]initWithDictionary:[dicServerAlert objectForKey:kAlertTypes]];
        [dicServerAlert enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSDictionary *dicUnAction = (NSDictionary *)obj;
            __block BOOL isVersionCompleted = NO;
            [dicUnAction enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stopUnAction) {
                
                if([key isEqualToString:kPurePlayAlertsResponse]){
                    if([obj objectForKey:kUnActionedPurePlay]){
                        NSArray *aryUnactPurePlayAlertsResponse = [obj objectForKey:kUnActionedPurePlay];
                        if([aryUnactPurePlayAlertsResponse count] > 0){
                            if([[aryUnactPurePlayAlertsResponse objectAtIndex:0] objectForKey:kVersion]){
                                version = [[aryUnactPurePlayAlertsResponse objectAtIndex:0] objectForKey:kVersion];
                                isVersionCompleted = YES;
                                *stopUnAction = YES;
                            }
                        }
                    }
                }else if ([key isEqualToString:kSkuVoidAlertsResponse]){
                    if([obj objectForKey:kUnActionedSKUVoids]){
                        NSArray *aryUnactSkuAlertsResponse = [obj objectForKey:kUnActionedSKUVoids];
                        if([aryUnactSkuAlertsResponse count] > 0){
                            if([[aryUnactSkuAlertsResponse objectAtIndex:0] objectForKey:kVersion]){
                                version = [[aryUnactSkuAlertsResponse objectAtIndex:0] objectForKey:kVersion];
                                isVersionCompleted = YES;
                                *stopUnAction = YES;
                            }
                        }
                    }
                }else if ([key isEqualToString:kMissingSkuInPogAlertsResponse]){
                    if([obj objectForKey:kUnActionedMissingSKUs]){
                        NSArray *aryUnactMisSkuAlertsResponse = [obj objectForKey:kUnActionedMissingSKUs];
                        if([aryUnactMisSkuAlertsResponse count] > 0){
                            if([[aryUnactMisSkuAlertsResponse objectAtIndex:0] objectForKey:kVersion]){
                                version = [[aryUnactMisSkuAlertsResponse objectAtIndex:0] objectForKey:kVersion];
                                isVersionCompleted = YES;
                                *stopUnAction = YES;
                            }
                        }
                    }
                }else if ([key isEqualToString:kInnovationAlertsResponse]){
                    if([obj objectForKey:kUnActionedInnovation]){
                        NSArray *aryUnactInnAlertsResponse = [obj objectForKey:kUnActionedInnovation];
                        if([aryUnactInnAlertsResponse count] > 0){
                            if([[aryUnactInnAlertsResponse objectAtIndex:0] objectForKey:kVersion]){
                                version = [[aryUnactInnAlertsResponse objectAtIndex:0] objectForKey:kVersion];
                                isVersionCompleted = YES;
                                *stopUnAction = YES;
                            }
                        }
                    }
                }
            }];
            if(isVersionCompleted){
                *stop = YES;
            }
            
        }];
    }
    return version;
}

#pragma mark - ckeck actioned alert saved locally

-(BOOL)isActionedAlertSavedLocalForStoreId:(NSString *)storeId{
    Configuration *config = [[SICoreDataManager sharedDataManager]fetchConfigurationDetailsForstoreID:storeId];
    BOOL isLocalActionAlert = [[SICoreDataManager sharedDataManager]isActionedALertSavedLocal:config];
    return isLocalActionAlert;
}

#pragma mark -Differentiate Alerts

-(NSMutableDictionary *)getCountForAlerts:(int)isActioned{
    
    int totalUnActionedAlertCount=0;
    int totalActionedAlertCount = 0;
    NSMutableDictionary *alertsCountDictionary=[NSMutableDictionary dictionary];
    
    //Skuvoids
    
    NSMutableArray *skuVoidsArray=[NSMutableArray arrayWithArray:[self fetchAlertsOfType:SKUVOIDS forActioned:isActioned]];
    NSString *skuAlertsCount=[NSString stringWithFormat:@"%lu",(unsigned long)skuVoidsArray.count];
    
    if (isActioned==Completed)
        totalActionedAlertCount=skuAlertsCount.intValue;
    else
        totalUnActionedAlertCount=skuAlertsCount.intValue;
    
    [alertsCountDictionary setObject:skuAlertsCount forKey:kSKUVoids];
    
    
    //missingSKus
    
    NSMutableArray *missingSKUsArray=[NSMutableArray arrayWithArray:[self fetchAlertsOfType:MISSINGSKUSINPOG forActioned:isActioned]];
    NSString *missingSKUsCount =[NSString stringWithFormat:@"%lu",(unsigned long)missingSKUsArray.count];
    [alertsCountDictionary setObject:missingSKUsCount forKey:kSKUMissinginPOG];
    
    if (isActioned==Completed)
        totalActionedAlertCount= totalActionedAlertCount+missingSKUsCount.intValue;
    else
        totalUnActionedAlertCount=totalUnActionedAlertCount+missingSKUsCount.intValue;
    
    //innovationAlerts
    
    NSMutableArray *innovationArray=[NSMutableArray arrayWithArray:[self fetchAlertsOfType:INNOVATION forActioned:isActioned]];
    NSString *innovationAlertsCount=[NSString stringWithFormat:@"%lu",(unsigned long)innovationArray.count];
    [alertsCountDictionary setObject:innovationAlertsCount forKey:kInnovationOpportunity];
    
    if (isActioned==Completed)
        totalActionedAlertCount= totalActionedAlertCount+innovationAlertsCount.intValue;
    else
        totalUnActionedAlertCount=totalUnActionedAlertCount+innovationAlertsCount.intValue;
    
    
    //pureplayAlerts
    
    NSMutableArray *purePlayArray=[NSMutableArray arrayWithArray:[self fetchAlertsOfType:PUREPLAY forActioned:isActioned]];
    NSString *purePlayCount=[NSString stringWithFormat:@"%lu",(unsigned long)purePlayArray.count];
    [alertsCountDictionary setObject:purePlayCount forKey:kPurePlayOpportunity];
    if (isActioned==Completed)
        totalActionedAlertCount= totalActionedAlertCount+purePlayCount.intValue;
    else
        totalUnActionedAlertCount=totalUnActionedAlertCount+purePlayCount.intValue;
    
    //Total UnactionedAlertCount
    
    NSString *unactionedAlertCount=[NSString stringWithFormat:@"%lu",(unsigned long)totalUnActionedAlertCount];
    [alertsCountDictionary setObject:unactionedAlertCount forKey:kUnactionedAlertsCount];
    
    //Total Actioned Alert Count
    NSString *actionedAlertCount=[NSString stringWithFormat:@"%lu",(unsigned long)totalActionedAlertCount];
    [alertsCountDictionary setObject:actionedAlertCount forKey:kActionedAlertsCount];
    
    
    return alertsCountDictionary;
    
}

-(NSMutableArray *)fetchAlertsOfType:(int)alertType forActioned:(int)isActioned{
    
    NSMutableDictionary *alertsDictionary=[SIBaseLogic fetchAlertswithStoreID:[SIUtiliesController getStoreID] forAlertType:alertType];
    
    NSMutableArray *alertsArray=[NSMutableArray array];
    
    if (isActioned==Completed)
    {
        alertsArray=[NSMutableArray arrayWithArray:[alertsDictionary objectForKey:kActioned]];
    }
    else
    {
        alertsArray=[NSMutableArray arrayWithArray:[alertsDictionary objectForKey:kUnActioned]];
    }
    
    NSMutableArray *arrayAlerts;
    
    arrayAlerts=[NSMutableArray arrayWithArray:alertsArray];
    
    return arrayAlerts;
    
}

-(void)differentiateActiveAndUnactiveAlerts:(NSDictionary *)alertsDictionary forAlertType:(int)alertType{
    
    
    NSMutableDictionary *alertInfoDict=[NSMutableDictionary dictionary];

    NSString *alertID=[NSString stringWithFormat:@"%@",[alertsDictionary objectForKey:kAlertID]];
    
    
    [alertInfoDict setObject:[SIBaseLogic alertIDToName:alertID.intValue] forKey:kAlertType];
    [alertInfoDict setObject:[alertsDictionary objectForKey:kAlertID] forKey:kAlertID];
    [alertInfoDict setObject:[alertsDictionary objectForKey:kStoreID] forKey:kStoreID];
    
    NSMutableArray *unactionedAlerts;
    NSMutableArray *actionedAlerts;
    
    if (alertType==PUREPLAY) {
        
        actionedAlerts=[alertsDictionary objectForKey:kActionedPurePlay];
        unactionedAlerts=[alertsDictionary objectForKey:kUnActionedPurePlay];

        [[SICoreDataManager sharedDataManager] insertPurePlayAlerts:actionedAlerts forActionedAlerts:YES withAlertsInfo:alertInfoDict];
        [[SICoreDataManager sharedDataManager] insertPurePlayAlerts:unactionedAlerts forActionedAlerts:NO withAlertsInfo:alertInfoDict];
    }
    else if (alertType==SKUVOIDS) {
        
        actionedAlerts=[alertsDictionary objectForKey:kActionedSKUVoids];
        unactionedAlerts=[alertsDictionary objectForKey:kUnActionedSKUVoids];
        
        [[SICoreDataManager sharedDataManager] insertSKUVoidsAlerts:actionedAlerts forActionedAlerts:YES withAlertsInfo:alertInfoDict];
        [[SICoreDataManager sharedDataManager] insertSKUVoidsAlerts:unactionedAlerts forActionedAlerts:NO withAlertsInfo:alertInfoDict];
    }
    else if (alertType==MISSINGSKUSINPOG) {
        
        actionedAlerts=[alertsDictionary objectForKey:kActionedMissingSKUs];
        unactionedAlerts=[alertsDictionary objectForKey:kUnActionedMissingSKUs];
        
        [[SICoreDataManager sharedDataManager] insertMissingSKUAlerts:actionedAlerts forActionedAlerts:YES withAlertsInfo:alertInfoDict];
        [[SICoreDataManager sharedDataManager] insertMissingSKUAlerts:unactionedAlerts forActionedAlerts:NO withAlertsInfo:alertInfoDict];
    }
    else if (alertType==INNOVATION) {
        
        actionedAlerts=[alertsDictionary objectForKey:kActionedInnovation];
        unactionedAlerts=[alertsDictionary objectForKey:kUnActionedInnovation];
        
        [[SICoreDataManager sharedDataManager] insertInnovationAlerts:actionedAlerts forActionedAlerts:YES withAlertsInfo:alertInfoDict];
        [[SICoreDataManager sharedDataManager] insertInnovationAlerts:unactionedAlerts forActionedAlerts:NO withAlertsInfo:alertInfoDict];
    }
}

-(void)refreshUpdatedAlerts{
    
        [[SIBaseLogic sharedSIBaseLogic].delegate submitAlertsSuccessful];

}

#pragma mark -alerts fetching


+(NSMutableDictionary *)fetchAlertswithStoreID:(NSString *)storeID forAlertType:(int)alertType{
    
    NSDictionary *tempDictionary;
    Configuration *configObj=[[SICoreDataManager sharedDataManager] fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    if (alertType==MISSINGSKUSINPOG) {
        
        tempDictionary=[[SICoreDataManager sharedDataManager] getmissingSKUAlertsForConfiguration:configObj];
    }
    else if (alertType==SKUVOIDS) {
        
        tempDictionary=[[SICoreDataManager sharedDataManager] getSKUVoidsAlertsForConfiguration:configObj];
    }
    else if (alertType==PUREPLAY) {
        tempDictionary=[[SICoreDataManager sharedDataManager] getPurePlayAlertsForConfiguration:configObj];
        
    }
    else if (alertType==INNOVATION) {
        
        tempDictionary=[[SICoreDataManager sharedDataManager] getInnovationAlertsForConfiguration:configObj];
    }
    
    NSMutableDictionary *alertsDictionay=[NSMutableDictionary dictionaryWithDictionary:tempDictionary];
    
    return alertsDictionay;
}


#pragma mark-alerts Updating

+(void)updateAlertsfor:(int)alertType withParameter:(NSString *)parameter toActionedFlag:(NSString *)actionTaken andVersion:(NSString *)version{
    
    Configuration* configObj=[[SICoreDataManager sharedDataManager] fetchConfigurationDetailsForstoreID:[SIUtiliesController getStoreID]];
    
    [[SICoreDataManager sharedDataManager] takeActionForAlerts:alertType withParameter:(NSString *)parameter toActionedFlag:actionTaken andConfiguration:configObj andVersion:version];
}

@end
