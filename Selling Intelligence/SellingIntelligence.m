//
//  Selling_Intelligence.m
//  Selling Intelligence
//
//  Created by Sailesh on 23/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SellingIntelligence.h"
#import "Selling_IntelligenceConstants.h"
#import "SIWebServiceParser.h"
#import "SIServiceAdaptor.h"
#import "SISubmitAlerts.h"

@interface SellingIntelligence()
{
    SIBaseLogic *baseLogic;
    SISubmitAlerts *submitalerts;
    UIActivityIndicatorView * activityIndicator;

}
@property (nonatomic, strong)SIAlertsFetcher *alertFetcher;

@end

@implementation SellingIntelligence
@synthesize isAlertDownloaded,progressSubViewSellingStories,progressSubViewSync,window,alertServerSyncError,lblMessage;

+ (instancetype) sharedSellingIntelligenceClass
{
    static SellingIntelligence *sharedSellingIntelligence = nil;
    static dispatch_once_t once_token;
    
    dispatch_once (&once_token, ^{
        sharedSellingIntelligence = [[SellingIntelligence alloc] init];
       
    });
    
    return sharedSellingIntelligence;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.alertFetcher=[[SIAlertsFetcher alloc]init];
        baseLogic=[[SIBaseLogic alloc]init];
        submitalerts=[[SISubmitAlerts alloc]init];
    }
    
    return self;
}


-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    
    self.backgroundTransferCompletionHandler = completionHandler;
    
}
-(void)loadSellingIntelligence:(UIViewController *)parentView forGPID:(NSString *)loginGPID withPassword:(NSString *)loginPassword{
    
    NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:kSIBundle];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    UIStoryboard *sellingStoryBoard = [UIStoryboard storyboardWithName:kSIStoryBoardName bundle:frameworkBundle];
    CGRect viewFrame;
    UINavigationController *nvc =[sellingStoryBoard instantiateViewControllerWithIdentifier:kSINavigation];
    
    [SIUtiliesController setPassword:loginPassword];

    if([[parentView childViewControllers] containsObject:nvc]){
    }
    else{
    }
    [parentView addChildViewController:nvc];
    
    [parentView.view addSubview:nvc.view];
    
    [nvc didMoveToParentViewController:parentView];

    
    viewFrame= CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    nvc.view.frame=viewFrame;
    nvc.view.center=parentView.view.center;

}


-(BOOL)unactionedAlertsToBeSubmitted{
    BOOL unactionedAlerts=NO;
   unactionedAlerts= [submitalerts unactionedAlertsToBeSubmitted];
    return unactionedAlerts;
}

-(void)downloadAlertsFromServer:(NSDictionary *)requestDict{
    [SIUtiliesController setStoreID:[requestDict objectForKey:kCustomerId]];
    [SIUtiliesController setgpID:[requestDict objectForKey:kGPID]];
    [SIUtiliesController setAppID:[requestDict objectForKey:kAppId]];
    [self.alertFetcher getAlertsDetails:requestDict];
}

-(void)cancelRequest{
    
    [[SIServiceAdaptor sharedWebServiceClient] cancelRequest];
}


-(int)getUnActionedAlertCount
{
    NSMutableDictionary *alertsDictUnActioned = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *alertsCountDictionary=[NSMutableDictionary dictionaryWithDictionary:[[SIBaseLogic sharedSIBaseLogic]getCountForAlerts:Open]];
    

    [alertsDictUnActioned setObject:alertsCountDictionary forKey:kUnActioned];
    
    NSString *strUnActionedAlertCount = [alertsCountDictionary objectForKey:kUnactionedAlertsCount];
    DebugLog(@"%@",strUnActionedAlertCount);
    
    int unActionedAlertCount = [strUnActionedAlertCount intValue];
    DebugLog(@"%d",unActionedAlertCount);
    
    return unActionedAlertCount;
}



-(int)getActionedAlertCount
{
    NSMutableDictionary *alertsDictActioned = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *alertsCountDictionaryForActioned=[NSMutableDictionary dictionaryWithDictionary:[[SIBaseLogic sharedSIBaseLogic]getCountForAlerts:Completed]];
    
    
    
    [alertsDictActioned setObject:alertsCountDictionaryForActioned forKey:kActioned];
    
    NSString *strActionedAlertCount = [alertsCountDictionaryForActioned objectForKey:kActionedAlertsCount];
    DebugLog(@"%@",strActionedAlertCount);
    
    int actionedAlertCount = [strActionedAlertCount intValue];
    DebugLog(@"%d",actionedAlertCount);
    
    
    return actionedAlertCount;
}

@end
