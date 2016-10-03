//
//  SICoreDataManager.h
//  Selling Intelligence
//
//  Created by Cognizant MSP on 01/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SICoreDataHandler.h"
#import "Configuration.h"
#import "Pureplay.h"
#import "SKUVoids.h"
#import "MissingSKUinPOG.h"
#import "Innovation.h"
#import "SIUtiliesController.h"
#import "Selling_IntelligenceConstants.h"
#import "SellingIntelligence.h"

@interface SICoreDataManager : NSObject

//Configuration

-(void)insertCustomerConfiguration:(NSDictionary *)configDictionary;
-(Configuration *)fetchConfigurationDetailsForstoreID:(NSString *)storeID;
-(NSMutableDictionary *)getConfigurationDetails;

//PurePlayAlerts

-(void)insertPurePlayAlerts:(NSArray *)ppAlertsDict forActionedAlerts:(BOOL)isActionedAlert withAlertsInfo:(NSDictionary *)alertInfoDict;
-(Pureplay *)fetchPurePlayForQuestionID:(NSString *)questionID andConfiguration:(Configuration *)configObj andVersion:(NSString *)version;
-(NSMutableDictionary *)getPurePlayAlertsForConfiguration:(Configuration *)configObj;

//SKU Voids
-(void)insertSKUVoidsAlerts:(NSArray *)skuAlertsArray forActionedAlerts:(BOOL)isActionedAlert withAlertsInfo:(NSDictionary *)alertInfoDict;
-(SKUVoids *)fetchSKUVoidsForUPCCode:(NSString *)upcCode andConfiguration:(Configuration *)configObj andVersion:(NSString *)version;
-(NSMutableDictionary *)getSKUVoidsAlertsForConfiguration:(Configuration *)configObj;


//Missing SKU Voids
-(void)insertMissingSKUAlerts:(NSArray *)missingSKUAlertsArray forActionedAlerts:(BOOL)isActionedAlert withAlertsInfo:(NSDictionary *)alertInfoDict;
-(MissingSKUinPOG *)fetchMissingSKUForUPCCode:(NSString *)upcCode andConfiguration:(Configuration *)configObj andVersion:(NSString *)version;
-(NSMutableDictionary *)getmissingSKUAlertsForConfiguration:(Configuration *)configObj;

//Innovation
-(void)insertInnovationAlerts:(NSArray *)innovationAlertsArray forActionedAlerts:(BOOL)isActionedAlert withAlertsInfo:(NSDictionary *)alertInfoDict;
-(Innovation *)fetchInnovationForUPCCode:(NSString *)upcCode andConfiguration:(Configuration *)configObj andVersion:(NSString *)version;
-(NSMutableDictionary *)getInnovationAlertsForConfiguration:(Configuration *)configObj;


//common
-(void)takeActionForAlerts:(int)alertType withParameter:(NSString *)parameter toActionedFlag:(NSString *)actionedType andConfiguration:(Configuration *)configObj andVersion:(NSString *)version;
-(void)insertSKUVoidsRateValue:(NSString *)rateValue withUPCCode:(NSString *)upcCode andVersion:(NSString *)version;
-(void)saveSubmittedAlerts;


-(void)saveMissingSKUAlertsSubmitted:(NSArray *)missingAlertsArray;
-(void)saveSkuAlertsSubmitted:(NSArray *)skuAlertsArray;
-(void)saveInnovationAlertsSubmitted:(NSArray *)innovationAlertsArray;
-(void)savePurePlayAlertsSubmitted:(NSArray *)purePlayAlertsArray;


-(void)clearDataForStoreId:(NSString *)storeId;
-(void)clearAllTableData;
-(BOOL)isActionedALertSavedLocal:(Configuration *)configObj;

+ (SICoreDataManager *)sharedDataManager;



@end
