//
//  SKUVoids.h
//  SellingIntelligence
//
//  Created by developer on 30/09/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Configuration;


@interface SKUVoids : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *alertCount;
@property (nullable, nonatomic, retain) NSString *alertID;
@property (nullable, nonatomic, retain) NSString *alertType;
@property (nullable, nonatomic, retain) NSString *altUPCCode;
@property (nullable, nonatomic, retain) NSString *gpId;
@property (nullable, nonatomic, retain) NSString *mfoId;
@property (nullable, nonatomic, retain) NSNumber *respondedFlag;
@property (nullable, nonatomic, retain) NSString *skuActionedDate;
@property (nullable, nonatomic, retain) NSString *skuAlertAction;
@property (nullable, nonatomic, retain) NSString *skuName;
@property (nullable, nonatomic, retain) NSString *skuRank;
@property (nullable, nonatomic, retain) NSString *skuRate;
@property (nullable, nonatomic, retain) NSString *skuVelocity;
@property (nullable, nonatomic, retain) NSString *upcCode;
@property (nullable, nonatomic, retain) NSString *version;
@property (nullable, nonatomic, retain) NSNumber *isYesActionEnabled;
@property (nullable, nonatomic, retain) NSNumber *isNoActionEnabled;
@property (nullable, nonatomic, retain) NSString *invenID;
@property (nullable, nonatomic, retain) Configuration *configuration;

@end

