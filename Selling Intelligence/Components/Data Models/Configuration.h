//
//  Configuration.h
//  SellingIntelligence
//
//  Created by CTS on 06/11/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Innovation, MissingSKUinPOG, Pureplay, SKUVoids;

@interface Configuration : NSManagedObject

@property (nonatomic, retain) NSNumber * actionedAlertCount;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSString * geoLevelID;
@property (nonatomic, retain) NSString * geoLevelTypeCode;
@property (nonatomic, retain) NSString * gpID;
@property (nonatomic, retain) NSNumber * isInnovation;
@property (nonatomic, retain) NSNumber * isMissingSKUs;
@property (nonatomic, retain) NSNumber * isPurePlay;
@property (nonatomic, retain) NSNumber * isSKUVoids;
@property (nonatomic, retain) NSDate * lastServiceCall;
@property (nonatomic, retain) NSString * srbNum;
@property (nonatomic, retain) NSString * storeID;
@property (nonatomic, retain) NSNumber * unActionedAlertCount;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSSet *innovation;
@property (nonatomic, retain) NSSet *missingSKU;
@property (nonatomic, retain) NSSet *purePlay;
@property (nonatomic, retain) NSSet *skuVoid;
@end

@interface Configuration (CoreDataGeneratedAccessors)

- (void)addInnovationObject:(Innovation *)value;
- (void)removeInnovationObject:(Innovation *)value;
- (void)addInnovation:(NSSet *)values;
- (void)removeInnovation:(NSSet *)values;

- (void)addMissingSKUObject:(MissingSKUinPOG *)value;
- (void)removeMissingSKUObject:(MissingSKUinPOG *)value;
- (void)addMissingSKU:(NSSet *)values;
- (void)removeMissingSKU:(NSSet *)values;

- (void)addPurePlayObject:(Pureplay *)value;
- (void)removePurePlayObject:(Pureplay *)value;
- (void)addPurePlay:(NSSet *)values;
- (void)removePurePlay:(NSSet *)values;

- (void)addSkuVoidObject:(SKUVoids *)value;
- (void)removeSkuVoidObject:(SKUVoids *)value;
- (void)addSkuVoid:(NSSet *)values;
- (void)removeSkuVoid:(NSSet *)values;

@end
