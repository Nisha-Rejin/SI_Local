//
//  SIAlertsSubmitParser.m
//  SellingIntelligence
//
//  Created by MSP on 01/11/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SISubmitAlertsParser.h"
#import "Selling_IntelligenceConstants.h"
#import "SellingIntelligence.h"
#import "SISubmitAlerts.h"

@interface SISubmitAlertsParser()
{
    
}
@property (nonatomic, strong)NSMutableDictionary *dicAlertRequest;

@end


@implementation SISubmitAlertsParser
@synthesize alertsSubmissionDictionary;

- (id)init {
    self = [super init];
    if (self)
    {
//        serviceAdaptor=[[SIServiceAdaptor alloc]init];
//        serviceAdaptor.delegate=self;
        [[SIServiceAdaptor sharedWebServiceClient]setDelegate:self];
    }
    
    return self;
}

-(void)submitAlertsWithRequest:(NSDictionary *)alertsSubmitDict{
    
//     serviceAdaptor.delegate=self;
    [[SIServiceAdaptor sharedWebServiceClient]setDelegate:self];
    
     self.dicAlertRequest = [[NSMutableDictionary alloc]initWithDictionary:alertsSubmitDict];
    
    NSString *urlString = [SIUtiliesController getSubmitAlertURLPath];
    
    [[SIServiceAdaptor sharedWebServiceClient]DownloadAlertsFromServer:urlString param:alertsSubmitDict failure:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle error - remove loader
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        [[SIBaseLogic sharedSIBaseLogic]alertsFetchFailedWithError:self error:error statusCode:(int)[httpResponse statusCode]];
        // call failed - removed loader - show alert
    } success:^(NSData *alertsData, NSError *error) {
        DebugLog(@"success - %@",urlString);
        [[SIBaseLogic sharedSIBaseLogic]setLastAlertUpdatedTime:[NSDate date]];
        [[SellingIntelligence sharedSellingIntelligenceClass]setIsAlertDownloaded:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadAlertsFromServer" object:self];
        NSError *parseError = nil;
        alertsSubmissionDictionary=[[NSMutableDictionary alloc]init];
        alertsSubmissionDictionary = [NSJSONSerialization JSONObjectWithData:alertsData options:kNilOptions error:& parseError];
        
        if (parseError != nil) {
            [super processParserError: parseError];
            return ;
        }
        if(alertsSubmissionDictionary.count > 0){
            if([alertsSubmissionDictionary objectForKey:kKeyStatusCode]){
                
                if([SIUtiliesController checkForNull:[alertsSubmissionDictionary objectForKey:kKeyStatusCode] forParameter:[NSString class]]) {
                    
                    if([[alertsSubmissionDictionary objectForKey:kKeyStatusCode] isEqualToString:kKeySubmitStatusCode]){
                        
                        [self completed];
                    }
                }
                else{
                    [[SIBaseLogic sharedSIBaseLogic] submitAlertsFailed];
                }

            }
        }else{
            DebugLog(@"fail - %@",urlString);
             if([alertsSubmissionDictionary objectForKey:kKeyStatusCode]){
                 if(![[alertsSubmissionDictionary objectForKey:kKeyStatusCode] isEqualToString:kKeySubmitStatusCode] || ![[alertsSubmissionDictionary objectForKey:kKeyStatusCode] isEqualToString:kKeyEmptyCode]){
                      if([alertsSubmissionDictionary objectForKey:kKeyFailDesc]){
                           [[SIBaseLogic sharedSIBaseLogic]alertsFetchFailedWithError:self error:[alertsSubmissionDictionary objectForKey:kKeyFailDesc]  statusCode:0];
                      }
                     
                  }
             }
           
        }
   
    }];
}


-(void)processParsing{
    
    NSError *parseError = nil;
    alertsSubmissionDictionary=[[NSMutableDictionary alloc]init];
    alertsSubmissionDictionary = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:& parseError];
    
    if (parseError != nil) {
        [super processParserError: parseError];
        return ;
    }
    if(alertsSubmissionDictionary.count > 0){
        if([alertsSubmissionDictionary objectForKey:kKeySubmitStatus]){
            if([[alertsSubmissionDictionary objectForKey:kKeySubmitStatus] isEqualToString:kSuccessValueSubmitStatus]){
                
                [self completed];
            }
        }
    }
}



- (void)closeNetworkConnection
{
//    if (serviceAdaptor.session != nil) {
//        [serviceAdaptor.session invalidateAndCancel];
//        serviceAdaptor.session = nil;
//    }
    
    if([[SIServiceAdaptor sharedWebServiceClient]session] != nil){
        [[[SIServiceAdaptor sharedWebServiceClient]session] invalidateAndCancel];
        [SIServiceAdaptor sharedWebServiceClient].session = nil;
    }
    
    if (self.delegate)
        self.delegate = nil;
}

-(void)sessionRenewed{
    [self submitAlertsWithRequest:self.dicAlertRequest];
}

@end
