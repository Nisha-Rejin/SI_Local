//
//  SISubmitAlerts.m
//  SellingIntelligence
//
//  Created by MSP on 01/11/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SISubmitAlerts.h"
#import "SIBaseLogic.h"
#import "SIReachability.h"
#import "SIUtiliesController.h"
#import "SellingIntelligence.h"
#import "SIUtility.h"


@interface SISubmitAlerts ()
{
    SIReachability *reachability;
    SIAlertsFetcher *alertsFetcher;
    NSMutableDictionary *skuAlertsDictionary,*missingSKUDictionary,*innovationDictionary,*purePlayDictionary;
    NSMutableDictionary *configDictionary,*alertsDictionary;
    NSMutableArray *alertTypesArray,*pureplayAlertsArray;
    NSMutableArray *skuAlertsArray,*arrayMissingAlerts,*arrayInnovation;

    
}

@end

@implementation SISubmitAlerts

- (id)init
{
    self = [super init];
    if (self)
    {
        submitAlertsParser=[[SISubmitAlertsParser alloc]init];
        submitAlertsParser.delegate = self;

    }
    return self;
}



-(void)submitAlerts:(NSDictionary *)alertsRequestDict
{
    
    reachability = [SIReachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    if ([reachability currentReachabilityStatus] == NotReachable){
        [[SIBaseLogic sharedSIBaseLogic]alertsFetchFailedWithError:nil error:nil statusCode:1009];
    }
    else{
        
        
//#warning sebastin - to be remove
//        
//        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        
//        for (NSHTTPCookie *each in [[cookieStorage cookiesForURL:[NSURL URLWithString:[self returnUrlString]]] copy]) {
//            [cookieStorage deleteCookie:each];
//        }
        
        
        [submitAlertsParser submitAlertsWithRequest:alertsRequestDict];
    }
}

//#warning sebastin - to be remove
//
//-(NSString*)returnUrlString{
//    
//    NSString *urlString = @"https://pepsitouch.ite.mypepsico.com/PTE-WS/security/authenticate";
//    
//    return urlString;
//}


-(void)finishedProcessing:(SIWebServiceParser *)provider{
    
    if ([provider isKindOfClass:[SISubmitAlertsParser class]])
    {
        NSMutableDictionary *reqDict = [NSMutableDictionary dictionary];
       
        [reqDict setObject:[SIUtiliesController getStoreID] forKey:kCustomerId];
        [reqDict setObject:[SIUtiliesController getAppID] forKey:kAppId];
        [reqDict setObject:[SIUtiliesController getgpID] forKey:kGPID];

        [[SICoreDataManager sharedDataManager]saveSubmittedAlerts];
        [SellingIntelligence sharedSellingIntelligenceClass].alertsSubmitted=YES;
        
         alertsFetcher=[[SIAlertsFetcher alloc]init];
        [alertsFetcher getAlertsDetails:reqDict];
    }
    
}

-(void)submitAlertsSuccessFul{
    
    
    [[SICoreDataManager sharedDataManager] saveSubmittedAlerts];
    
}


-(void)formAlertsSubmissionRequestForStoreID:(NSString *)storeID{
    
    Configuration *configObj=[[SICoreDataManager sharedDataManager] fetchConfigurationDetailsForstoreID:storeID];

    configDictionary=[NSMutableDictionary dictionary];
    configDictionary=[[SICoreDataManager sharedDataManager]getConfigurationDetails];
    skuAlertsDictionary=[NSMutableDictionary dictionary];
    skuAlertsDictionary=[[SICoreDataManager sharedDataManager] getSKUVoidsAlertsForConfiguration:configObj];
    missingSKUDictionary=[NSMutableDictionary dictionary];
    missingSKUDictionary=[[SICoreDataManager sharedDataManager] getmissingSKUAlertsForConfiguration:configObj];
    innovationDictionary=[NSMutableDictionary dictionary];
    innovationDictionary=[[SICoreDataManager sharedDataManager] getInnovationAlertsForConfiguration:configObj];
    purePlayDictionary=[NSMutableDictionary dictionary];
    purePlayDictionary=[[SICoreDataManager sharedDataManager] getPurePlayAlertsForConfiguration:configObj];
    
}

-(void)skuVoidsAlertstobesubmitted{
    
    NSMutableArray *skuAlerts=[NSMutableArray array];

    skuAlertsArray=[NSMutableArray array];
    skuAlerts=[skuAlertsDictionary objectForKey:kUnActioned];
    
    
    NSPredicate *predYES = [NSPredicate predicateWithFormat:@"actionedFlag==%@", kYes];
    NSArray *filteredYESarray = [skuAlerts filteredArrayUsingPredicate:predYES];
    
    NSPredicate *predNO = [NSPredicate predicateWithFormat:@"actionedFlag==%@", kNo];
    NSArray *filteredNOarray = [skuAlerts filteredArrayUsingPredicate:predNO];
    
    
    NSPredicate *predNA = [NSPredicate predicateWithFormat:@"actionedFlag==%@", @"NA"];
    NSArray *filteredNAarray = [skuAlerts filteredArrayUsingPredicate:predNA];

    [skuAlertsArray addObjectsFromArray:filteredYESarray];
    [skuAlertsArray addObjectsFromArray:filteredNOarray];
    
    
    NSMutableSet *bigSet=[NSMutableSet setWithArray:skuAlertsArray];
    [bigSet minusSet:[NSMutableSet setWithArray:filteredNAarray]];
    skuAlertsArray=[[bigSet allObjects]mutableCopy];
    
}

-(void)missingSKUAlertsToBeSubmitted{
    
    arrayMissingAlerts=[NSMutableArray array];
     NSMutableArray *MissingAlerts=[missingSKUDictionary objectForKey:kUnActioned];
    
    NSPredicate *predYES = [NSPredicate predicateWithFormat:@"actionedFlag==%@", kYes];
    NSArray *filteredYESarray = [MissingAlerts filteredArrayUsingPredicate:predYES];
    
    NSPredicate *predNO = [NSPredicate predicateWithFormat:@"actionedFlag==%@", kNo];
    NSArray *filteredNOarray = [MissingAlerts filteredArrayUsingPredicate:predNO];
    
    NSPredicate *predNA = [NSPredicate predicateWithFormat:@"actionedFlag==%@", @"NA"];
    NSArray *filteredNAarray = [MissingAlerts filteredArrayUsingPredicate:predNA];
    
    
    [arrayMissingAlerts addObjectsFromArray:filteredYESarray];
    [arrayMissingAlerts addObjectsFromArray:filteredNOarray];
    
    NSMutableSet *bigSet=[NSMutableSet setWithArray:arrayMissingAlerts];
    [bigSet minusSet:[NSMutableSet setWithArray:filteredNAarray]];
    arrayMissingAlerts=[[bigSet allObjects]mutableCopy];

}


-(void)innovationAlertsToBeSubmitted{
    
    arrayInnovation=[NSMutableArray array];
    NSMutableArray *innovationALerts=[innovationDictionary objectForKey:kUnActioned];
    
    NSPredicate *predYES = [NSPredicate predicateWithFormat:@"actionedFlag==%@", kYes];
    NSArray *filteredYESarray = [innovationALerts filteredArrayUsingPredicate:predYES];
    
    NSPredicate *predNO = [NSPredicate predicateWithFormat:@"actionedFlag==%@", kNo];
    NSArray *filteredNOarray = [innovationALerts filteredArrayUsingPredicate:predNO];
    
    
    NSPredicate *predNA = [NSPredicate predicateWithFormat:@"actionedFlag==%@", @"NA"];
    NSArray *filteredNAarray = [innovationALerts filteredArrayUsingPredicate:predNA];
    
    
    
    [arrayInnovation addObjectsFromArray:filteredYESarray];
    [arrayInnovation addObjectsFromArray:filteredNOarray];
    
    
    NSMutableSet *bigSet=[NSMutableSet setWithArray:arrayInnovation];
    [bigSet minusSet:[NSMutableSet setWithArray:filteredNAarray]];
    arrayInnovation=[[bigSet allObjects]mutableCopy];

}

-(void)checkForEmptyUnactionedAlerts{
    
    [self skuVoidsAlertstobesubmitted];
    [self missingSKUAlertsToBeSubmitted];
    [self innovationAlertsToBeSubmitted];
    
    NSMutableDictionary *alertsDict=[NSMutableDictionary dictionary];

    
    if (skuAlertsArray.count==0 && arrayMissingAlerts.count==0 && arrayInnovation.count==0) {
        
        alertsDict=[NSMutableDictionary new];
        [alertsDict setObject:@" " forKey:kUPC];
        [alertsDict setObject:@" " forKey:kSkuName];
        [alertsDict setObject:@" " forKey:kSkuId];
        [alertsDict setObject:@" " forKey:kSkuFlg];
        [alertsDict setObject:@" " forKey:kVersion];
        [alertsDict setObject:@" " forKey:kGPID];
        [alertsDict setObject:@" " forKey:kPogId];
        [alertsDict setObject:@" " forKey:kPogFlg];
        [alertsDict setObject:@" " forKey:kInnoId];
        [alertsDict setObject:@" " forKey:kInnoFlg];
        
        [alertTypesArray addObject:alertsDict];

    }
    
    
}

-(void)checkforCommonUpcCodes{
    
    alertTypesArray =[NSMutableArray array];
    
    NSMutableDictionary *alertsDict=[NSMutableDictionary dictionary];

    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    for (NSDictionary* skuDict in skuAlertsArray) {
        for (NSDictionary* missingSKUDict in arrayMissingAlerts) {
            for (NSDictionary* innovationDict in arrayInnovation) {
                
                NSString *skuUpc=[skuDict objectForKey:kUPC];
                NSString *missingUpc= [missingSKUDict objectForKey:kUPC];
                NSString *innovUPC=[innovationDict objectForKey:kUPC];
                
                if ([skuUpc isEqual:missingUpc] && [skuUpc isEqual:innovUPC]) {
                    
                    NSMutableDictionary* skuDictCopy = [skuDict mutableCopy];
                    NSMutableDictionary* missingSKUCopy = [missingSKUDict mutableCopy];
                    NSMutableDictionary* innovationDictCopy = [innovationDict mutableCopy];
               
                    [result addObject:skuDictCopy];
                    [result addObject:missingSKUCopy];
                    [result addObject:innovationDictCopy];
                    
                    alertsDict=[NSMutableDictionary new];
                    
                    [alertsDict setObject:[missingSKUDict objectForKey:kVersion] forKey:kVersion];
                    [alertsDict setObject:[SIUtiliesController getgpID] forKey:kGPID];
                    [alertsDict setObject:[skuDict objectForKey:kUPC] forKey:kUPC];
                    [alertsDict setObject:[skuDict objectForKey:kSkuName] forKey:kSkuName];
                    [alertsDict setObject:[skuDict objectForKey:kAlertID] forKey:kSkuId];
                    [alertsDict setObject:[skuDict objectForKey:kActionedFlag] forKey:kSkuFlg];
                    [alertsDict setObject:[missingSKUDict objectForKey:kAlertID] forKey:kPogId];
                    [alertsDict setObject:[missingSKUDict objectForKey:kActionedFlag] forKey:kPogFlg];
                    [alertsDict setObject:[innovationDict objectForKey:kAlertID] forKey:kInnoId];
                    [alertsDict setObject:[innovationDict objectForKey:kActionedFlag] forKey:kInnoFlg];
                    [alertTypesArray addObject:alertsDict];
                    break;
                    
                
                }
            }
        }
    }
    
    
    NSMutableSet *bigSet=[NSMutableSet setWithArray:skuAlertsArray];
    [bigSet minusSet:[NSMutableSet setWithArray:result]];
    skuAlertsArray=[[bigSet allObjects]mutableCopy];
    
    NSMutableSet *innovationSet=[NSMutableSet setWithArray:arrayInnovation];
    [innovationSet minusSet:[NSMutableSet setWithArray:result]];
    arrayInnovation=[[innovationSet allObjects]mutableCopy];
    
    NSMutableSet *missingSKUSet=[NSMutableSet setWithArray:arrayMissingAlerts];
    [missingSKUSet minusSet:[NSMutableSet setWithArray:result]];
    arrayMissingAlerts=[[missingSKUSet allObjects]mutableCopy];
    

}

-(void)checkforSKUandMissingSKuCommon{
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *alertsDict=[NSMutableDictionary dictionary];

     for (NSDictionary* skuDict in skuAlertsArray) {
        for (NSDictionary* missingSKUDict in arrayMissingAlerts) {
            NSString *skuUpc=[skuDict objectForKey:kUPC];
            NSString *missingUpc= [missingSKUDict objectForKey:kUPC];
            if ([skuUpc isEqual:missingUpc]) {
                NSMutableDictionary* skuDictCopy = [skuDict mutableCopy];
                NSMutableDictionary* missingSKUCopy = [missingSKUDict mutableCopy];
                
                [result addObject:skuDictCopy];
                [result addObject:missingSKUCopy];
                
                alertsDict=[NSMutableDictionary new];
                [alertsDict setObject:[skuDict objectForKey:kUPC] forKey:kUPC];
                [alertsDict setObject:[skuDict objectForKey:kSkuName] forKey:kSkuName];
                [alertsDict setObject:[skuDict objectForKey:kAlertID] forKey:kSkuId];
                [alertsDict setObject:[skuDict objectForKey:kActionedFlag] forKey:kSkuFlg];
                [alertsDict setObject:[missingSKUDict objectForKey:kAlertID] forKey:kPogId];
                [alertsDict setObject:[missingSKUDict objectForKey:kActionedFlag] forKey:kPogFlg];
                [alertsDict setObject:@" " forKey:kInnoId];
                [alertsDict setObject:@" " forKey:kInnoFlg];
                [alertsDict setObject:[missingSKUDict objectForKey:kVersion] forKey:kVersion];
                [alertsDict setObject:[SIUtiliesController getgpID] forKey:kGPID];

                [alertTypesArray addObject:alertsDict];

                
                break;
            }
        }
    }
    
    
    NSMutableSet *bigSet=[NSMutableSet setWithArray:skuAlertsArray];
    [bigSet minusSet:[NSMutableSet setWithArray:result]];
    skuAlertsArray=[[bigSet allObjects]mutableCopy];
    
    NSMutableSet *missingSKUSet=[NSMutableSet setWithArray:arrayMissingAlerts];
    [missingSKUSet minusSet:[NSMutableSet setWithArray:result]];
    arrayMissingAlerts=[[missingSKUSet allObjects]mutableCopy];

}
-(void)checkforInnovationandMissingSKuCommon{
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *alertsDict=[NSMutableDictionary dictionary];

    for (NSDictionary* innovationDict in arrayInnovation) {
        for (NSDictionary* missingDict in arrayMissingAlerts) {
            NSString *innoUpc=[innovationDict objectForKey:kUPC];
            NSString *missingUpc= [missingDict objectForKey:kUPC];
            if ([innoUpc isEqual:missingUpc]) {
                NSMutableDictionary* innovationCopy = [innovationDict mutableCopy];
                NSMutableDictionary* missingCopy = [missingDict mutableCopy];
                
                [result addObject:innovationCopy];
                [result addObject:missingCopy];
                
                alertsDict=[NSMutableDictionary new];

                [alertsDict setObject:[innovationDict objectForKey:kUPC] forKey:kUPC];
                [alertsDict setObject:[innovationDict objectForKey:kSkuName] forKey:kSkuName];
                [alertsDict setObject:@" " forKey:kSkuId];
                [alertsDict setObject:@" " forKey:kSkuFlg];
                [alertsDict setObject:[missingDict objectForKey:kAlertID] forKey:kPogId];
                [alertsDict setObject:[missingDict objectForKey:kActionedFlag] forKey:kPogFlg];
                [alertsDict setObject:[innovationDict objectForKey:kAlertID] forKey:kInnoId];
                [alertsDict setObject:[innovationDict objectForKey:kActionedFlag] forKey:kInnoFlg];
                [alertsDict setObject:[innovationDict objectForKey:kVersion] forKey:kVersion];
                [alertsDict setObject:[SIUtiliesController getgpID] forKey:kGPID];

                [alertTypesArray addObject:alertsDict];
                
                break;
            }
        }
    }
    
    
 
    
    NSMutableSet *innovationSet=[NSMutableSet setWithArray:arrayInnovation];
    [innovationSet minusSet:[NSMutableSet setWithArray:result]];
    arrayInnovation=[[innovationSet allObjects]mutableCopy];
    
    NSMutableSet *missingSKUSet=[NSMutableSet setWithArray:arrayMissingAlerts];
    [missingSKUSet minusSet:[NSMutableSet setWithArray:result]];
    arrayMissingAlerts=[[missingSKUSet allObjects]mutableCopy];
    
}

-(void)checkforSKUandInnovationCommon{
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSMutableDictionary *alertsDict=[NSMutableDictionary dictionary];

    for (NSDictionary* innovationDict in arrayInnovation) {
        for (NSDictionary* skuDict in skuAlertsArray) {
            NSString *innoUpc=[innovationDict objectForKey:kUPC];
            NSString *skuUPC= [skuDict objectForKey:kUPC];
            if ([innoUpc isEqual:skuUPC]) {
                
                NSMutableDictionary* innovationDictCopy = [innovationDict mutableCopy];
                NSMutableDictionary* skuDictCopy = [skuDict mutableCopy];
                
                [result addObject:innovationDictCopy];
                [result addObject:skuDictCopy];
                
                alertsDict=[NSMutableDictionary new];

                [alertsDict setObject:[innovationDict objectForKey:kUPC] forKey:kUPC];
                [alertsDict setObject:[innovationDict objectForKey:kSkuName] forKey:kSkuName];
                [alertsDict setObject:[skuDict objectForKey:kAlertID] forKey:kSkuId];
                [alertsDict setObject:[skuDict objectForKey:kActionedFlag] forKey:kSkuFlg];
                [alertsDict setObject:@" " forKey:kPogId];
                [alertsDict setObject:@" " forKey:kPogFlg];
                [alertsDict setObject:[innovationDict objectForKey:kAlertID] forKey:kInnoId];
                [alertsDict setObject:[innovationDict objectForKey:kActionedFlag] forKey:kInnoFlg];
                [alertsDict setObject:[innovationDict objectForKey:kVersion] forKey:kVersion];
                [alertsDict setObject:[SIUtiliesController getgpID] forKey:kGPID];

                [alertTypesArray addObject:alertsDict];
                
                break;
            }
        }
    }
    
    
    NSMutableSet *bigSet=[NSMutableSet setWithArray:skuAlertsArray];
    [bigSet minusSet:[NSMutableSet setWithArray:result]];
    skuAlertsArray=[[bigSet allObjects]mutableCopy];
    
    NSMutableSet *innovationSet=[NSMutableSet setWithArray:arrayInnovation];
    [innovationSet minusSet:[NSMutableSet setWithArray:result]];
    arrayInnovation=[[innovationSet allObjects]mutableCopy];
    
}

-(void)checkforIndividualUPC{
    
    NSMutableDictionary *alertsDict=[NSMutableDictionary dictionary];
    
    for (NSDictionary *skuDict in skuAlertsArray) {
        alertsDict=[NSMutableDictionary new];

        [alertsDict setObject:[skuDict objectForKey:kUPC] forKey:kUPC];
        [alertsDict setObject:[skuDict objectForKey:kSkuName] forKey:kSkuName];
        [alertsDict setObject:[skuDict objectForKey:kAlertID] forKey:kSkuId];
        [alertsDict setObject:[skuDict objectForKey:kActionedFlag] forKey:kSkuFlg];
        [alertsDict setObject:[skuDict objectForKey:kVersion] forKey:kVersion];
        [alertsDict setObject:[SIUtiliesController getgpID] forKey:kGPID];

        [alertsDict setObject:@" " forKey:kPogId];
        [alertsDict setObject:@" " forKey:kPogFlg];
        [alertsDict setObject:@" " forKey:kInnoId];
        [alertsDict setObject:@" " forKey:kInnoFlg];
        [alertTypesArray addObject:alertsDict];

    }
    
    for (NSDictionary *missingSKUDict in arrayMissingAlerts) {
        
        alertsDict=[NSMutableDictionary new];
        
        [alertsDict setObject:[missingSKUDict objectForKey:kVersion] forKey:kVersion];
        [alertsDict setObject:[missingSKUDict objectForKey:kUPC] forKey:kUPC];
        [alertsDict setObject:[missingSKUDict objectForKey:kSkuName] forKey:kSkuName];
        [alertsDict setObject:@" " forKey:kSkuId];
        [alertsDict setObject:@" " forKey:kSkuFlg];
        [alertsDict setObject:[missingSKUDict objectForKey:kAlertID] forKey:kPogId];
        [alertsDict setObject:[missingSKUDict objectForKey:kActionedFlag] forKey:kPogFlg];
        [alertsDict setObject:@" " forKey:kInnoId];
        [alertsDict setObject:@" " forKey:kInnoFlg];
        [alertsDict setObject:[SIUtiliesController getgpID] forKey:kGPID];

        [alertTypesArray addObject:alertsDict];


    }
    for (NSDictionary *innovationDict in arrayInnovation) {
        
        alertsDict=[NSMutableDictionary new];
        
        [alertsDict setObject:[SIUtiliesController getgpID] forKey:kGPID];
        [alertsDict setObject:[innovationDict objectForKey:kVersion] forKey:kVersion];
        [alertsDict setObject:[innovationDict objectForKey:kUPC] forKey:kUPC];
        [alertsDict setObject:[innovationDict objectForKey:kSkuName] forKey:kSkuName];
        [alertsDict setObject:@" " forKey:kSkuId];
        [alertsDict setObject:@" " forKey:kSkuFlg];
        [alertsDict setObject:@" " forKey:kPogId];
        [alertsDict setObject:@" " forKey:kPogFlg];
        [alertsDict setObject:[innovationDict objectForKey:kAlertID] forKey:kInnoId];
        [alertsDict setObject:[innovationDict objectForKey:kActionedFlag] forKey:kInnoFlg];
        [alertTypesArray addObject:alertsDict];
        
        
    }
    
    
    
    if (alertTypesArray.count==0) {
        alertsDict=[NSMutableDictionary new];
        
        [alertsDict setObject:@" " forKey:kVersion];
        [alertsDict setObject:@" " forKey:kUPC];
        [alertsDict setObject:@" " forKey:kSkuName];
        [alertsDict setObject:@" " forKey:kSkuId];
        [alertsDict setObject:@" " forKey:kSkuFlg];
        [alertsDict setObject:@" " forKey:kPogId];
        [alertsDict setObject:@" " forKey:kPogFlg];
        [alertsDict setObject:@" " forKey:kPogId];
        [alertsDict setObject:@" " forKey:kPogFlg];
        [alertsDict setObject:@" " forKey:kInnoId];
        [alertsDict setObject:@" " forKey:kInnoFlg];
        [alertsDict setObject:@" " forKey:kGPID];
        
//        [alertTypesArray addObject:alertsDict];
    }
    
    
    DebugLog(@"actionedAlerts----->%@",alertTypesArray);

    
}


-(void)formPureplaySubmitRequest{
    
    pureplayAlertsArray=[NSMutableArray array];
    NSMutableArray *arrayPureplay=[NSMutableArray array];
    arrayPureplay=[purePlayDictionary objectForKey:kUnActioned];
    
    NSMutableDictionary *ppAlertsList=nil;
    
    for (NSDictionary *purePlayDict in arrayPureplay) {
        
        NSString *actionedFlag=[purePlayDict objectForKey:kActionedFlag];
        
        ppAlertsList=[NSMutableDictionary new];
        
        if ([SIUtiliesController checkForNull:actionedFlag forParameter:[NSString class]]) {
            
            [ppAlertsList setObject:[purePlayDict objectForKey:kHeaderId] forKey:kHeaderId];
            [ppAlertsList setObject:[purePlayDict objectForKey:kQuestionId] forKey:kQuestionId];
            [ppAlertsList setObject:[purePlayDict objectForKey:kQuestionDescription] forKey:kQuestionDescription];
            [ppAlertsList setObject:[purePlayDict objectForKey:kImageId] forKey:kImageId];
            [ppAlertsList setObject:[purePlayDict objectForKey:kDefId]forKey:kDefId];
            [ppAlertsList setObject:[purePlayDict objectForKey:kActionedFlag] forKey:kActionedFlag];
            [ppAlertsList setObject:[purePlayDict objectForKey:kVersion] forKey:kVersion];
            [ppAlertsList setObject:[purePlayDict objectForKey:kAlertID] forKey:kPureplayId];
            [ppAlertsList setObject:[SIUtiliesController getgpID] forKey:kGPID];

            [pureplayAlertsArray addObject:ppAlertsList];
        }
        
    }
    
    
    
    [pureplayAlertsArray setArray:[[NSSet setWithArray:pureplayAlertsArray] allObjects]];


}

- (void)formRequestForSubmittingAlerts:(BOOL)isSubmission{
    
    NSMutableDictionary *submitReqDict = [NSMutableDictionary dictionary];
    [self formAlertsSubmissionRequestForStoreID:[SIUtiliesController getStoreID]];
    
    //take from config table
    [submitReqDict setObject:[configDictionary objectForKey:kStoreID] forKey:kCustomerId];
    [submitReqDict setObject:[configDictionary objectForKey:kCountryCode] forKey:kCountryCode];
    [submitReqDict setObject:[configDictionary objectForKey:kGeoLevelId] forKey:kGeoLevelId];
    [submitReqDict setObject:[configDictionary objectForKey:kGeoLevelTypeCode] forKey:kGeoLevelTypeCode];
    [submitReqDict setObject:[configDictionary objectForKey:ksrbuNum] forKey:ksrbuNum];
    [submitReqDict setObject:kMFOIDVALUE forKey:kMfoId];
    [submitReqDict setObject:[SIUtiliesController getAppID]  forKey:kAppId];
    
    
    //Alert Types
    
    [self checkForEmptyUnactionedAlerts];
    [self checkforCommonUpcCodes];
    [self checkforSKUandMissingSKuCommon];
    [self checkforInnovationandMissingSKuCommon];
    [self checkforSKUandInnovationCommon];
    [self checkforIndividualUPC];
    [self formPureplaySubmitRequest];

    
    

    
    [submitReqDict setObject:alertTypesArray forKey:kActionedAlertsRequest];
    
    if (pureplayAlertsArray.count>0) {
        [submitReqDict setObject:pureplayAlertsArray forKey:kPurePlayActionedRequest];
    }
    else
    {
        
        NSMutableDictionary *ppAlertsList=[NSMutableDictionary dictionary];
        pureplayAlertsArray=[NSMutableArray array];

        [ppAlertsList setObject:@" " forKey:kHeaderId];
        [ppAlertsList setObject:@" " forKey:kQuestionId];
        [ppAlertsList setObject:@" " forKey:kQuestionDescription];
        [ppAlertsList setObject:@" " forKey:kImageId];
        [ppAlertsList setObject:@" " forKey:kDefId];
        [ppAlertsList setObject:@" " forKey:kActionedFlag];
        [ppAlertsList setObject:@" " forKey:kVersion];
        [ppAlertsList setObject:@" " forKey:kPureplayId];
        [ppAlertsList setObject:@" " forKey:kGPID];

//        [pureplayAlertsArray addObject:ppAlertsList];
        
        [submitReqDict setObject:pureplayAlertsArray forKey:kPurePlayActionedRequest];
    }
        
    DebugLog(@"%@",submitReqDict);
   if(isSubmission)
    [self submitAlerts:submitReqDict];
    
}

-(BOOL)unactionedAlertsToBeSubmitted{
    [self formRequestForSubmittingAlerts:NO];
    BOOL isAlertsToBeSubmitted=NO;
    if (alertTypesArray.count>0 && pureplayAlertsArray.count>0) {
        isAlertsToBeSubmitted=YES;
    }
    return isAlertsToBeSubmitted;
}





- (void)handleNetworkOfParser:(SIWebServiceParser *)manager andParsingErrors:(NSError *)error andStatusCode:(int)statusCode
{
    [[SIBaseLogic sharedSIBaseLogic]alertsFetchFailedWithError:manager error:error statusCode:statusCode];
}

- (void)handleSSLNetworkErrorOfParser:(SIWebServiceParser *)manager
{
    [[SIBaseLogic sharedSIBaseLogic]alertsFetchFailedWithError:manager error:nil statusCode:0];
}

@end
