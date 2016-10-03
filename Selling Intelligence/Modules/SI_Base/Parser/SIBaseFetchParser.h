//
//  SIBaseFetchParser.h
//  SellingIntelligence
//
//  Created by Cognizant MSP on 29/10/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SIWebServiceParser.h"

@interface SIBaseFetchParser : SIWebServiceParser<ServiceAdaptorDelegate>


@property(nonatomic,strong)NSMutableDictionary *alertsRetrevialDictionary;

-(void)getalertsResponse:(NSDictionary *)alertsRequestDict;


@end


