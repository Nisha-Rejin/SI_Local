//
//  SIAlertsFetcher.m
//  SellingIntelligence
//
//  Created by CTS on 30/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SIAlertsFetcher.h"
#import "SIReachability.h"
#import "SIUtiliesController.h"
#import "SIUtility.h"
#import "Selling_IntelligenceConstants.h"
#import "SIBaseLogic.h"

@interface SIAlertsFetcher ()
    {
        SIReachability *reachability;
    }

@end


@implementation SIAlertsFetcher




- (id)init
{
    self = [super init];
    if (self)
    {
        fetchParser=[[SIBaseFetchParser alloc]init];
        fetchParser.delegate = self;
        
     }
    return self;
}


-(void)getAlertsDetails:(NSDictionary *)alertsRequestDict
{
    
    reachability = [SIReachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    if ([reachability currentReachabilityStatus] == NotReachable){
        [[SIBaseLogic sharedSIBaseLogic]alertsFetchFailedWithError:nil error:nil statusCode:1009];
    }else{
        [fetchParser getalertsResponse:alertsRequestDict];
    }
}



-(void)finishedProcessing:(SIWebServiceParser *)provider{
    
    if ([provider isKindOfClass:[SIBaseFetchParser class]])
    {
        NSMutableDictionary *alertsRetrevalDict = ((SIBaseFetchParser *)provider).alertsRetrevialDictionary;
        
        if ([[alertsRetrevalDict allKeys]count] >0) {
            [[SIBaseLogic sharedSIBaseLogic]getAlertsResponseSuccessful:alertsRetrevalDict];
        }
    }
    
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
