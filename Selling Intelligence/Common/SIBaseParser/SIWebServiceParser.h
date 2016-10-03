//
//  SIWebServiceManager.h
//  SellingIntelligence
//
//  Created by CTS on 15/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIServiceAdaptor.h"

@class SIWebServiceParser;

typedef void (^WebServiceSuccess)(BOOL *result);
typedef void (^WebServiceFailure)(NSURL *url, NSError *error);


@protocol SIServiceManagerParser <NSObject>

@optional

// Called by the provider when parsing is finished

- (void)finishedProcessing:(SIWebServiceParser *)provider;
- (void)handleNetworkOfParser:(SIWebServiceParser *)provider andParsingErrors:(NSError *)error andStatusCode:(int)statusCode;
- (void)handleSSLNetworkErrorOfParser:(SIWebServiceParser *)provider;

@end

@interface SIWebServiceParser : NSObject<ServiceAdaptorDelegate>
{
    NSString *operationName;
    NSString *serviceName,*requestServiceURL;
    NSDictionary *requestDictionary;
    NSData *data,*requestServiceData;
    __weak id <SIServiceManagerParser> delegate;
    NSInteger serviceStatusCode;
}

@property (nonatomic, copy) WebServiceSuccess sucessBlock;
@property (nonatomic, copy) WebServiceFailure failureBlock;
@property (nonatomic, copy) NSString *entity;
@property (nonatomic, copy) NSString *urlAsString;

//Queue of webservices
@property (nonatomic, retain) NSData *data;
@property (nonatomic, weak) id <SIServiceManagerParser> delegate;


//parser methods and service methods
- (void)setResponseData:(NSData *)responsedata;
- (void)completed;
- (void)processParsing;
- (void)processParserError:(NSError *)error;
-(id)init;



@end