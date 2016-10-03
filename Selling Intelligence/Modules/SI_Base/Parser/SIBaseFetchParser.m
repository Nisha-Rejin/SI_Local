//
//  SIBaseFetchParser.m
//  SellingIntelligence
//
//  Created by Cognizant MSP on 29/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SIBaseFetchParser.h"
#import "SIUtiliesController.h"
#import "Selling_IntelligenceConstants.h"
#import "SellingIntelligence.h"
#import "SIServiceAdaptor.h"
#import "SIBaseLogic.h"
//#import "LoginManager.h"

@interface SIBaseFetchParser (){
    

}
@property (nonatomic, strong)NSMutableDictionary *dicAlertRequest;
@end


@implementation SIBaseFetchParser
@synthesize alertsRetrevialDictionary;



- (id)init {
    self = [super init];
    if (self)
    {
        [[SIServiceAdaptor sharedWebServiceClient]setDelegate:self];
    }
    
    return self;
}

-(void)getalertsResponse:(NSDictionary *)alertsRequestDict{
    
    [[SIServiceAdaptor sharedWebServiceClient]setDelegate:self];
    
    self.dicAlertRequest = [[NSMutableDictionary alloc]initWithDictionary:alertsRequestDict];
    
    NSString *urlString = [SIUtiliesController getFetchAlertURLPath];

    
    [[SIServiceAdaptor sharedWebServiceClient]DownloadAlertsFromServer:urlString param:alertsRequestDict failure:^(NSData *errorData, NSURLResponse *response, NSError *error) {
    
         // handle error - remove loader
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        [[SIBaseLogic sharedSIBaseLogic]alertsFetchFailedWithError:self error:error statusCode:(int)[httpResponse statusCode]];
    } success:^(NSData *alertsData, NSError *error) {

        DebugLog(@"success - %@",urlString);
        
        
        [[SIBaseLogic sharedSIBaseLogic]setLastAlertUpdatedTime:[NSDate date]];
        
        [[SellingIntelligence sharedSellingIntelligenceClass]setIsAlertDownloaded:YES];
       
        
        
        NSError *parseError = nil;
        alertsRetrevialDictionary=[[NSMutableDictionary alloc]init];
        alertsRetrevialDictionary = [NSJSONSerialization JSONObjectWithData:alertsData options:kNilOptions error:& parseError];
        
        if (parseError != nil) {
            [super processParserError: parseError];
            return ;
        }
        
        if(alertsRetrevialDictionary.count > 0){
            if([[SIBaseLogic sharedSIBaseLogic]isLocalAndSeverAlertVersionSame:alertsRetrevialDictionary storeId:[SIUtiliesController getStoreID]]){
                [self completed];
            }else{
                [[SICoreDataManager sharedDataManager]clearDataForStoreId:[SIUtiliesController getStoreID]];
                [self completed];
            }
        }else{
            DebugLog(@"fail - %@",urlString);
            if([alertsRetrevialDictionary objectForKey:kKeyStatusCode]){
                if(![[alertsRetrevialDictionary objectForKey:kKeyStatusCode] isEqualToString:kKeySubmitStatusCode] || ![[alertsRetrevialDictionary objectForKey:kKeyStatusCode] isEqualToString:kKeyEmptyCode]){
                    if([alertsRetrevialDictionary objectForKey:kKeyFailDesc]){
                        [[SIBaseLogic sharedSIBaseLogic]alertsFetchFailedWithError:self error:[alertsRetrevialDictionary objectForKey:kKeyFailDesc]  statusCode:0];
                    }
                }
            }
        }
}];
    
}


-(void)processParsing{
    
    NSError *parseError = nil;
    alertsRetrevialDictionary=[[NSMutableDictionary alloc]init];
    alertsRetrevialDictionary = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:& parseError];
    
    if (parseError != nil) {
        [super processParserError: parseError];
        return ;
    }
    
    if(alertsRetrevialDictionary.count > 0){
        if([[SIBaseLogic sharedSIBaseLogic]isLocalAndSeverAlertVersionSame:alertsRetrevialDictionary storeId:[SIUtiliesController getStoreID]]){
            [self completed];
        }else{
            [[SICoreDataManager sharedDataManager]clearDataForStoreId:[SIUtiliesController getStoreID]];
            [self completed];
        }
    }
}



- (void)closeNetworkConnection
{
    
    if([[SIServiceAdaptor sharedWebServiceClient]session] != nil){
        [[[SIServiceAdaptor sharedWebServiceClient]session] invalidateAndCancel];
        [SIServiceAdaptor sharedWebServiceClient].session = nil;
    }
    
    if (self.delegate)
        self.delegate = nil;
}


-(void)sessionRenewed{
    [self getalertsResponse:self.dicAlertRequest];
}

@end
