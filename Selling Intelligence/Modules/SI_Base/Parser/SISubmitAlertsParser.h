//
//  SIAlertsSubmitParser.h
//  SellingIntelligence
//
//  Created by MSP on 01/11/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//


#import "SIWebServiceParser.h"

@interface SISubmitAlertsParser : SIWebServiceParser

@property(nonatomic,strong)NSMutableDictionary *alertsSubmissionDictionary;

-(void)submitAlertsWithRequest:(NSDictionary *)alertsSubmitDict;

@end
