//
//  Pureplay.h
//  SellingIntelligence
//
//  Created by developer on 30/09/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Configuration;

@interface Pureplay : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *alertCount;
@property (nullable, nonatomic, retain) NSString *alertID;
@property (nullable, nonatomic, retain) NSNumber *alertType;
@property (nullable, nonatomic, retain) NSString *defID;
@property (nullable, nonatomic, retain) NSString *gpId;
@property (nullable, nonatomic, retain) NSString *headerID;
@property (nullable, nonatomic, retain) NSString *imageID;
@property (nullable, nonatomic, retain) NSString *mfoId;
@property (nullable, nonatomic, retain) NSString *ppAction;
@property (nullable, nonatomic, retain) NSString *ppActionedDate;
@property (nullable, nonatomic, retain) NSString *pureplayName;
@property (nullable, nonatomic, retain) NSString *questionID;
@property (nullable, nonatomic, retain) NSNumber *respondedFlag;
@property (nullable, nonatomic, retain) NSString *version;
@property (nullable, nonatomic, retain) NSNumber *isNoActionEnabled;
@property (nullable, nonatomic, retain) NSNumber *isYesActionEnabled;
@property (nullable, nonatomic, retain) Configuration *configuration;

@end

