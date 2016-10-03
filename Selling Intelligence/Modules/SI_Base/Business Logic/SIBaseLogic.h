//
//  Selling_Intelligence.m
//  Selling Intelligence
//
//  Created by Sailesh on 29/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIAlertsFetcher.h"
#import "SICoreDataHandler.h"
#import "SICoreDataManager.h"
#import "SIUtiliesController.h"
#import "Selling_IntelligenceConstants.h"
#import "SIBaseFetchParser.h"


@protocol alertsLoaderDelegate <NSObject>

@optional

-(void)submitAlertsSuccessful;
-(void)loadSkuAlerts;
-(void)loadMissingSKUSAlerts;
-(void)loadInnovationAlerts;
-(void)loadPurePlayAlerts;


@end

@class SIWebServiceParser;

@interface SIBaseLogic : NSObject<SIServiceManagerParser>


@property (nonatomic, assign) id <alertsLoaderDelegate> delegate;


@property (nonatomic, strong)NSDate *lastAlertUpdatedTime;

+ (instancetype)sharedSIBaseLogic;

//Common Methods

+(NSString*)alertEnumToString:(int)selectedAlert;
+(NSString*)alertIDToName:(int)alertID;
+(NSBundle *)libraryBundlePath;

//Inserting and Fetching
-(void)getAlertsResponseSuccessful:(NSDictionary *)alertsResponseDict;
-(void)alertsFetchFailedWithError:(SIWebServiceParser*)parser error:(NSError*)error statusCode:(int)statusCode;

-(void)categorizedSellingIntelligence:(NSDictionary *)alertsDictionary;
+(NSMutableDictionary *)fetchAlertswithStoreID:(NSString *)storeID forAlertType:(int)alertType;
-(void)readAlertsJson;

//Updating Values

+(void)updateAlertsfor:(int)alertType withParameter:(NSString *)parameter toActionedFlag:(NSString *)actionTaken andVersion:(NSString *)version;

//Differentiating

-(NSMutableDictionary *)getCountForAlerts:(int)isActioned;
-(NSMutableArray *)fetchAlertsOfType:(int)alertType forActioned:(int)isActioned;

//Get Methods
+(NSMutableArray *)unactionedAlertsTypes;

+(NSMutableArray *)getAlertsBaseArray:(NSMutableArray *)alertsArray;

-(BOOL)isLocalAndSeverAlertVersionSame:(NSDictionary *)dicServerAlert storeId:(NSString *)storeId;

-(BOOL)isActionedAlertSavedLocalForStoreId:(NSString *)storeId;

//Failed

-(void)submitAlertsFailed;

@end
