//
//  SIServiceAdaptor.m
//  SellingIntelligence
//
//  Created by CTS on 15/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SIServiceAdaptor.h"
#import "SIWebServiceParser.h"
#import "LoginManager.h"
#import "SIUtiliesController.h"
#import "Selling_IntelligenceConstants.h"
#import "SIUtility.h"
#import "SellingIntelligence.h"

#define BACKGROUND_SESSION_STRING_NAME @"com.pepsico.cco.background-session"
#define URLSESSION_TIMEOUT_PERIOD 60.0
#define URLSESSION_MAX_CONNECTIONS 10

#define kTimeoutInterval 120.0
#define kAccept          @"Accept"
#define kApplicationType @"application/json"
#define kAccept          @"Accept"
#define kContentType     @"Content-Type"
#define kCookie          @"Cookie"

@interface SIServiceAdaptor()<LoginManagerDelegate>
{
    
}
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation SIServiceAdaptor
@synthesize delegate, session,webServiceDownloadQueue;

+ (instancetype) sharedWebServiceClient
{
    static SIServiceAdaptor *sharedAdapter = nil;
    static dispatch_once_t once_token;
    
    dispatch_once (&once_token, ^{
        sharedAdapter = [[SIServiceAdaptor alloc] init];
    });
    
    return sharedAdapter;
}

- (id)init
{
    if (self = [super init])
    {
        self.webServiceDownloadQueue = [NSMutableDictionary new];
        NSURLSessionConfiguration *sessionconfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionconfig.timeoutIntervalForRequest = URLSESSION_TIMEOUT_PERIOD;
        sessionconfig. HTTPMaximumConnectionsPerHost = URLSESSION_MAX_CONNECTIONS;
        self.session = [NSURLSession sessionWithConfiguration:sessionconfig delegate:self delegateQueue:nil];
    }
    
    return self;
}

-(void)cancelRequest{
    
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
            [self cancelTasksInArray:dataTasks];
            [self cancelTasksInArray:uploadTasks];
            [self cancelTasksInArray:downloadTasks];
    }];
}

- (void)cancelTasksInArray:(NSArray *)tasksArray
{
    for (NSURLSessionTask *task in tasksArray) {
        [task cancel];
    }
}

- (void)makeServiceCallWithRequest:(NSMutableURLRequest *)theRequest
                           success:(void (^)(NSData *data, NSError *error))success
                           failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure
{
    self.responseData = [NSMutableData data];
    
    /* Method 1 */
    
    NSURLSessionDataTask *postTask = [self.session dataTaskWithRequest:theRequest completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (!error)
                                          {
                                              [self.responseData appendData:data];
                                              
                                              
                                              NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse *)response;
                                              
                                              [httpresponse statusCode] == 200
                                              ? success(self.responseData,nil)
                                              : failure(data,response,error);
                                              
                                          }
                                          else
                                          {
                                              failure(data,response,error);
                                          }
                                      }];
    
    
    [postTask resume];
}

- (void)DownloadAlertsFromServer:(NSString *)urlAsString
                           param:(NSDictionary *)param
                         failure:(void (^)(NSData *data, NSURLResponse *response, NSError *error))failure
                         success:(void (^)(NSData *alertsData, NSError *error))success
{
    
    NSURL *loginURL = [NSURL URLWithString:urlAsString];
    NSError *error = nil;
    NSData *requestData;
    if (param!=nil) {
      requestData = [NSJSONSerialization dataWithJSONObject:param options:kNilOptions error:&error];
    }
    
    NSURL *pWebServerURL = nil;
    
    pWebServerURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@", loginURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:pWebServerURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeoutInterval];
    
    [theRequest setTimeoutInterval:kTimeoutInterval];
    [theRequest setValue:nil forHTTPHeaderField:kCookie];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:kApplicationType forHTTPHeaderField:kAccept];
    [theRequest setValue:kApplicationType forHTTPHeaderField:kContentType];
    
    [theRequest setHTTPBody: requestData];
    
//    NSString* newStr = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    
    
    
    DebugLog(@"requestDict = %@", [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding]);

    [self makeServiceCallWithRequest:(NSMutableURLRequest *)theRequest success:^(NSData *alertsData, NSError *error) {
        
//        NSString *responseString = [[NSString alloc] initWithData:alertsData encoding:NSUTF8StringEncoding];
        // insert into core data
        
        DebugLog(@"responseDict = %@", [[NSString alloc] initWithData:alertsData encoding:NSUTF8StringEncoding]);
        
        NSString *responseString = [[NSString alloc] initWithData:alertsData encoding:NSUTF8StringEncoding];
        if ([SIUtiliesController isHtmlString:responseString]){
            [self performSelectorOnMainThread:@selector(invokeDelayedAuthentication) withObject:nil waitUntilDone:NO];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(alertsData, nil);
        });
        
    } failure:^(NSData *data, NSURLResponse *response, NSError *error) {
        
//        NSString *responseString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        DebugLog(@"responseString = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([SIUtiliesController isHtmlString:responseString]){
            [self performSelectorOnMainThread:@selector(invokeDelayedAuthentication) withObject:nil waitUntilDone:NO];
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            failure(data,response,error);
        });
        
    }];
    
}

-(void)responseDataSuccessful:(NSData *)responseData{
    
    [self.delegate setResponseData:responseData];
}





#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session  task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    DebugLog(@"didSendBodyData");  //  Works with all the methods
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    DebugLog(@"didReceiveResponse");   // Works when Method 3 is used
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
    DebugLog(@"didReceiveData");   // Not working with any method
}

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
//{
//    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
//}


#pragma mark - handle timeout

#pragma mark Login Manager

- (void)invokeDelayedAuthentication
{
    LoginManager *logManager = [LoginManager sharedInstance];
    
    logManager.delegate = self;
    
//#warning sebastin - remove this
//    
//    [logManager validateAgainstServerWithGPID:[SIUtiliesController getgpID] andPass:@"asdasd"];
    
    [logManager validateAgainstServerWithGPID:[SIUtiliesController getgpID] andPass:[SIUtiliesController getPassword]];
}

#pragma Login Manager Delegate Methods

-(void)userSuccessfullyAuthenticated:(AuthenticationSourceType)authenticationSource
{
    //[self getalertsResponse:self.dicAlertRequest];
    [self.delegate sessionRenewed];
}

-(void)userFailedToAuthorize:(AuthenticationError) authenticationError
{
    
    [[SIUtility sharedUtility]removeProgressView];
    [SIUtiliesController showAlertWithMessage:@"Your session has expired. Please log in again." title:KAPPNAME];
    if ([SellingIntelligence sharedSellingIntelligenceClass].alertsSubmitted) {
        [SellingIntelligence sharedSellingIntelligenceClass].alertsSubmitted=NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kSessionExpiredNotificationName
                                                       object:nil userInfo:nil];
}


@end
