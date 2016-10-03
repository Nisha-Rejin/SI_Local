//
//  SIWebServiceManager.m
//  SellingIntelligence
//
//  Created by CTS on 15/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SIWebServiceParser.h"
#import "SIServiceAdaptor.h"


#define kTimeoutInterval 120.0
#define kAccept          @"Accept"
#define kApplicationType @"application/json"
#define kAccept          @"Accept"
#define kContentType     @"Content-Type"
#define kCookie          @"Cookie"

@implementation SIWebServiceParser
//@synthesize serviceAdaptor;
@synthesize delegate,data;




-(id)init
{
    self = [super init];
    
    if (self)
    {
        
        [[SIServiceAdaptor sharedWebServiceClient]setDelegate:self];
    }
    
    return self;
}



- (void)completed {
    if ([self.delegate respondsToSelector:@selector(finishedProcessing:)]) {
        
        [self.delegate finishedProcessing:self];
    }
}

- (void)processParsing{
    //empty implementation & class which extends the baseparser should have the implemenetation.
}

- (void)processParserError: (NSError *)error {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleNetworkOfParser:andParsingErrors:andStatusCode:)]) {
        [self.delegate handleNetworkOfParser:self andParsingErrors:error andStatusCode:(int)serviceStatusCode];
    }
}

#pragma mark -
#pragma mark ServiceAgentDelegate Implementation
- (void)setResponseData:(NSData *)responsedata{
    @synchronized(responsedata){
        self.data = [NSData dataWithData:responsedata];
        
     
         [self processParsing];
    }
}

- (void)closeNetworkConnection {
    [self completed];
}

- (void)handleError:(NSError *)error {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleNetworkOfParser:andParsingErrors:andStatusCode:)]) {
        [self.delegate handleNetworkOfParser:self andParsingErrors:error andStatusCode:(int)serviceStatusCode];
    }
}

- (void)handleSSLError
{
    DebugLog(@"*** handleSSLError ***");
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleSSLNetworkErrorOfParser:)])
    {
        [self.delegate handleSSLNetworkErrorOfParser:self];
    }
}

-(void)handleSessionTimeOut:(NSString*)requestURL requestData:(NSData*)requestData requestDictionary:(NSDictionary*)reqDict
{
    requestServiceURL=requestURL;
    requestServiceData=requestData;
    requestDictionary=reqDict;
    
    /* serviceStatusCode=403;
     [self handleError:nil];*/
    
}

- (void)didReceiveStatusCode:(NSNumber*)statusCode {
    serviceStatusCode = [statusCode intValue];
}


#pragma mark -
#pragma mark Clean Up
- (void)dealloc {
//    [serviceAdaptor setDelegate:nil];
    
}


@end
