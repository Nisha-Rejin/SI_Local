//
//  SIServiceAdaptor.h
//  SellingIntelligence
//
//  Created by CTS on 15/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServiceAdaptorDelegate <NSObject>
@optional
-(void)handleSessionTimeOut:(NSString*)requestURL requestData:(NSData*)requestData requestDictionary:(NSDictionary*)reqDict;

@required
- (void)setResponseData:(NSData *)data;
- (void)closeNetworkConnection;
- (void)handleError:(NSError *)error;
- (void)didReceiveStatusCode:(NSNumber*)statusCode;
- (void)handleSSLError;
- (void)sessionRenewed;
@end

@interface SIServiceAdaptor : NSObject<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>
{
@private
    __weak id <ServiceAdaptorDelegate> delegate;

}
@property (nonatomic, weak)__weak id <ServiceAdaptorDelegate> delegate;
@property (strong, nonatomic) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *webServiceDownloadQueue;

/**
 * Shared instance for getting access to the singleton PPSHTTPClient
 */
+ (instancetype) sharedWebServiceClient;

/**
 * NSURLSession used by the http client
 */

-(void)cancelRequest;

/**
 *  Creates a download task for the given URL
 *  @param url The URL from which the download has to be triggered
 *  @param success A block object notifying the success response and data.
 *  @param failure A block object representing the failure
 *
 */



- (void)DownloadAlertsFromServer:(NSString *)urlAsString
                           param:(NSDictionary *)param
                         failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure
                         success:(void (^)(NSData *alertsData, NSError *error))success;


- (void)makeServiceCallWithRequest:(NSMutableURLRequest *)theRequest
                           success:(void (^)(NSData *data, NSError *error))success
                           failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure;

@end
