//
//  LoginConfig.h
//  SecurityPatternApp
//
//  Created by Fowler, John X - Contractor {BIS} on 7/20/12.
//  Copyright (c) 2013 PepsiCo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Common.h"

@interface LoginConfig : NSObject


+(LoginConfig *)config;



-(NSString *)brand;
-(NSString *)environment;


-(void) loadFenceValues;
-(NSString *)getDaysToStayAlive;
-(NSString *)getHoursToStayAlive;


-(NSString *)getValueFromPlist:(NSString *)key;
-(NSString *)getValueFromPlist:(NSString *)key withModule:(NSString *)moduleName;
-(NSString *)getValueFromPlist:(NSString *)key withModule:(NSString *)moduleName andModulePlistName:(NSString *)modulePlistName;


-(NSMutableDictionary *)simSettings;
-(void)saveSimSettings:(NSDictionary *)settings;

@end
