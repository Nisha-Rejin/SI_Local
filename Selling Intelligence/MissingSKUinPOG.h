//
//  MissingSKUinPOG.h
//  SellingIntelligence
//
//  Created by developer on 30/09/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Configuration;

@interface MissingSKUinPOG : NSManagedObject

@property (nullable, nonatomic, retain) NSString *alertID;
@property (nullable, nonatomic, retain) NSNumber *alertsCount;
@property (nullable, nonatomic, retain) NSString *alertType;
@property (nullable, nonatomic, retain) NSString *altUPCCode;
@property (nullable, nonatomic, retain) NSString *gpId;
@property (nullable, nonatomic, retain) NSString *mfoId;
@property (nullable, nonatomic, retain) NSString *missingSKUName;
@property (nullable, nonatomic, retain) NSString *pogActionedDate;
@property (nullable, nonatomic, retain) NSString *pogAlertAction;
@property (nullable, nonatomic, retain) NSNumber *respondedFlag;
@property (nullable, nonatomic, retain) NSString *upcCode;
@property (nullable, nonatomic, retain) NSString *version;
@property (nullable, nonatomic, retain) NSNumber *isYesActionEnabled;
@property (nullable, nonatomic, retain) NSNumber *isNoActionEnabled;
@property (nullable, nonatomic, retain) Configuration *configuration;

@end

